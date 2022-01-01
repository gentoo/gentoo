# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_NAME="bcrypt"

inherit multilib ruby-fakegem

DESCRIPTION="An easy way to keep your users' passwords secure"
HOMEPAGE="https://github.com/codahale/bcrypt-ruby"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/git ls-files/d' bcrypt.gemspec || die
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
