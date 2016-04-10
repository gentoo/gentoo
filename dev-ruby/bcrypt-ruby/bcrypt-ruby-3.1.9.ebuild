# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_NAME="bcrypt"

inherit multilib ruby-fakegem

DESCRIPTION="An easy way to keep your users' passwords secure"
HOMEPAGE="https://github.com/codahale/bcrypt-ruby"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/git ls-files/d' bcrypt.gemspec || die
	# Fix tests until RSpec3 is available
	sed -i -e 's/truthy/true/' -e 's/falsey/false/' spec/bcrypt/password_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/mri extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/mri V=1
	cp ext/mri/*$(get_modname) lib/ || die
}

each_ruby_install() {
		each_fakegem_install

		# bcrypt was called bcrypt-ruby before, so add a spec file that
		# simply loads bcrypt to make sure that old projects load correctly
		# we don't even need to create a file to load this: the `require
		# bcrypt` was already part of bcrypt-ruby requirements.
		cat - <<EOF > "${T}/bcrypt-ruby.gemspec"
Gem::Specification.new do |s|
	s.name = "bcrypt-ruby"
	s.version = "${RUBY_FAKEGEM_VERSION}"
	s.summary = "Fake gem to load bcrypt"
	s.homepage = "${HOMEPAGE}"
	s.specification_version = 3
	s.add_runtime_dependency("${RUBY_FAKEGEM_NAME}", ["= ${RUBY_FAKEGEM_VERSION}"])
end
EOF
		RUBY_FAKEGEM_NAME=bcrypt-ruby \
				RUBY_FAKEGEM_GEMSPEC="${T}/bcrypt-ruby.gemspec" \
				ruby_fakegem_install_gemspec
}
