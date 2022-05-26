# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.md"

MY_PN=${PN/-/_}
RUBY_FAKEGEM_EXTENSIONS=(ext/${MY_PN}/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Liquid performance extension in C"
HOMEPAGE="https://github.com/Shopify/liquid-c"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/liquid-5.0.1:*"

all_ruby_prepare() {
	sed -i -e "s/-Werror//" ext/${MY_PN}/extconf.rb || die
	sed -i -e "/[Bb]undler/d" Rakefile || die
}
