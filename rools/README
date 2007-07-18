
= Rools -- A pure ruby rules-engine

Rools is a rules engine for abstracting business logic and program-flow. It's ideally suited to processing applications where the business logic undergoes frequent modification.

== RubyForge
	This documentation can be found at http://rools.rubyforge.org
	The project page can be found at http://rubyforge.org/projects/rools
	
== Example

	require 'rools'
	
	rules = Rools::RuleSet.new do
		
		rule 'Hello?' do
			parameter String
			consequence { puts "Hello, Rools!" }
		end
	end
	
	rules.assert 'Heya'
	
	> Hello, Rools!

	
You can also store your rules in a separate file, and pass a path to Rools::RuleSet#new instead of a block. e.g.
	
	require 'rools'
	
	rules = Rools::RuleSet.new 'test/data/hello.rules'
	rules.assert 'heya'

=== Parameter

The +parameter+ method accepts Constants and/or Symbols. Every constant in the list is called with :is_a? on the asserted object, while every symbol in the list is passed to :respond_to? on the asserted object. In other words:

	parameter Person, :name, :occupation
	
Is effectively the same as:

	condition { object.is_a?(Person) && object.responds_to?(:name) && object.responds_to?(:occupation) }
	
The +parameter+ method is obviously preferred for it's conciseness, and because the working set of rules can be optimized to only include for evaluation those rules whose parameters match the asserted object.

=== Condition

The +condition+ method is used to evaluate the asserted object. You can have any number of conditions. Rools::DefaultParameterProc#method_missing is used so that you can refer to the asserted object by practically any +lower_case_underscore+ name. Generally you'll want to use names that make sense in the context of the +Rule+, and be consistent through-out the +Rule+. Here's an example:

	rule 'Programmer' do
		condition { person.occupation == 'coder' }
		consequence { puts "#{person} is a coder" }
	end
	
Here's an example of something you might want to avoid:

	rule 'Manager' do
		condition { obj.occupation == 'manager' }
		consequence { puts "#{manager} is a manager" }
	end

Both examples are syntactically correct, but the first is easier to read.

=== Consequence

A consequence is a block of code that executes if the conditions evaluate to true. You can have one or more consequences. In the above examples we're doing something simple such as just printing something to the string in the consequences. Usually the consequence is something that will actually change the state of the asserted object in some way however.

	rule 'User' do
		parameter User, :failed_login_attempts
		condition { user.failed_login_attempts > 3 }
		consequence { user.lockout! }
	end
	
Nevermind that this is application logic you'd probably keep in your domain model. The intent isn't to show you best-practices here, only to make the point that consequences usually modify state.

=== Assert

What happens if in a +consequence+, you need to create other objects though? You can use the +assert+ method in a +consequence+. Consider the following:

	rule 'Message is Referral?' do
		parameter :subject, :body

		condition { message.subject == 'Sales Referral' }
		condition { message.body =~ /^How\sdid\syou\shear\sabout\sbrand\sX\?/m }

		consequence { assert Referral.new(message) }
	end
	
	rule 'Referral is Large Account' do
		parameter Referral

		condition { referral.annual_sales_volume > 100_000_000 }
		consequence { referral.prioritize :high }
	end

The first rule asserted a new +Referral+ object into the RuleSet. You could also assert into a completey different RuleSet however if you need to split them up to keep them manageable:

	consequence { RuleSet.new('referral.rules').assert Referral.new(message) }
	
=== Extend

Problem: You have a sequence of rules that depend on each other:

	rule 'Valid User' do
		condition { user.valid? }
		condition { user.password.size > 6 }
		consequence { puts "#{user} is valid" }
	end

	rule 'Active User' do
		condition { user.valid? }
		condition { user.password.size > 6 }
		condition { user.last_logon < 1.month.ago }
		condition do
			user.logins_for(:january).inject(0) do |sum, duration|
				sum += duration
			end > 5.minutes
		end

		consequence { puts "#{user} is active" }
	end

	rule 'Administrative User' do
		condition { user.valid? }
		condition { user.password.size > 6 }
		condition { user.last_logon < 1.month.ago }
		condition do
			user.logins_for(:january).inject(0) do |sum, duration|
				sum += duration
			end > 5.minutes
		end
		condition { user.admin? }

		consequence { puts "#{user} is an admin" }
	end
	
This chain of rules quickly becomes rather cumbersome. To help, you can use the +extend+ -> +with+ syntax to enable chaining and branching rules. The same example as above could also be written this way: (extend rule_name with new_rule_name)

	rule 'Valid User' do
		condition { user.valid? }
		condition { user.password.size > 6 }
		consequence { puts "#{user} is valid" }
	end
	
	extend('Valid User').with('Active User') do
		condition { user.last_logon < 1.month.ago }
		condition do
			user.logins_for(:january).inject(0) do |sum, duration|
				sum += duration
			end > 5.minutes
		end
		
		consequence { puts "#{user} is active" }
	end
	
	extend('Active User').with('Administrative User') do
		condition { user.admin? }	
		consequence { puts "#{user} is an admin" }
	end
	
In this simplistic example, it saves 11 lines (about a third), but in more complex examples you could easily end up with half the code. The first example could perform up to 11 condition checks for a valid, active, admin user. Because the extend syntax defers adding the dependent rules to the working set until the extended rule evaluates to true, the extend syntax would do the same work with only 5 comparisons (less than half the work). For expensive operations, such as file operations, regular expressions, or database calls, the extend syntax is potentially several times faster than the "brute-force" method, and the difference only becomes greater the larger your RuleSet.

It's important to remember that you can only extend rules within the same Rools::RuleSet.

You can also +extend+ a target rule +with+ several additional rules at once with a block:

	extend('Active User') do
		with 'Administrative User' do
			condition { user.admin? }	
			consequence { puts "#{user} is an admin" }
		end
		
		with 'Customer User' do
			condition { user.customer? }
			consequence { puts "#{user} is a customer" }
		end
	end

Rule names are case-insensitive. It's important to give good descriptive names to rules as not only does it make maintaining them much easier, but it also gives you better logging, and makes +extend+ calls easier to follow.