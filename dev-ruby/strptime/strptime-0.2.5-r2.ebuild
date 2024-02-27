# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="strptime.gemspec"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_EXTENSIONS=(ext/strptime/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/strptime

inherit multilib ruby-fakegem

DESCRIPTION="A fast strptime/strftime engine which uses VM"
HOMEPAGE="https://github.com/nurse/strptime"
SRC_URI="https://github.com/nurse/strptime/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	local -x TZ=UTC # bug #775380
	each_fakegem_test
}
