# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
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
	dev-ruby/i18n:*
	!!<dev-ruby/capistrano-2.15.5-r2"
ruby_add_bdepend "
	test? (	dev-ruby/mocha )"

all_ruby_prepare() {
	# Avoid specs that depend on capistrano already being installed
	rm -f spec/lib/capistrano/doctor/gems_doctor_spec.rb || die

	# Avoid specs that require a TTY
	sed -i -e '/asking for a variable/,/^  end/ s:^:#:' spec/integration/dsl_spec.rb || die
	rm -f spec/lib/capistrano/configuration/question_spec.rb || die
}
