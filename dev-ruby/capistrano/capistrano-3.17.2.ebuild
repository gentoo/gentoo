# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="https://capistranorb.com/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/airbrussh-1.0.0
	>=dev-ruby/sshkit-1.9:0
	>=dev-ruby/rake-10.0.0
	dev-ruby/i18n:*"
ruby_add_bdepend "
	test? (	dev-ruby/mocha )"

all_ruby_prepare() {
	# Avoid specs that depend on capistrano already being installed
	rm -f spec/lib/capistrano/doctor/gems_doctor_spec.rb || die

	# Avoid specs that require a TTY
	sed -i -e '/asking for a variable/,/^  end/ s:^:#:' spec/integration/dsl_spec.rb || die
	rm -f spec/lib/capistrano/configuration/question_spec.rb spec/lib/capistrano/doctor/output_helpers_spec.rb || die
}
