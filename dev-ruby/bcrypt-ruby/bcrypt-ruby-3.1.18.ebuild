# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_NAME="bcrypt"

RUBY_FAKEGEM_EXTENSIONS=(ext/mri/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="An easy way to keep your users' passwords secure"
HOMEPAGE="https://github.com/codahale/bcrypt-ruby"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e 's/git ls-files/find */' bcrypt.gemspec || die
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
