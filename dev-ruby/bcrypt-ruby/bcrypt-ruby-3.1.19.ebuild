# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_NAME="bcrypt"

RUBY_FAKEGEM_EXTENSIONS=(ext/mri/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="An easy way to keep your users' passwords secure"
HOMEPAGE="https://github.com/bcrypt-ruby/bcrypt-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e 's/git ls-files/find */' bcrypt.gemspec || die
}
