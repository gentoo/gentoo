# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRAINSTALL="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Making tests easy on the fingers and eyes"
HOMEPAGE="https://github.com/thoughtbot/shoulda-matchers"
SRC_URI="https://github.com/thoughtbot/shoulda-matchers/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Fedora manage to run the tests, but it's still pretty tricky.
# https://src.fedoraproject.org/rpms/rubygem-shoulda-matchers/blob/rawhide/f/rubygem-shoulda-matchers.spec
RESTRICT="test"

ruby_add_rdepend ">=dev-ruby/activesupport-5.2.0:*"

all_ruby_prepare() {
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb || die

	#rm Gemfile.lock || die

	# Avoid Appraisal and Bundler.
	#sed -i "/current_bundle/ s/^/#/" \
	#	spec/acceptance_spec_helper.rb \
	#	spec/support/unit/load_environment.rb || die
	#sed -i "/CurrentBundle/ s/^/#/" \
	#	spec/acceptance_spec_helper.rb \
	#	spec/support/unit/load_environment.rb || die

	# Avoid git and sprockets dependencies.
	#sed -i '/def rails_new_command/,/^    end$/ {
	#	/rails new/ s/"$/ --skip-git --skip-asset-pipeline&/
	#}' spec/support/unit/rails_application.rb || die
	#sed -i '/def rails_new_command/,/^    end$/ {
	#	/rails new/ s/"$/ --skip-git --skip-asset-pipeline&/
	#}' spec/support/acceptance/helpers/step_helpers.rb || die
}
