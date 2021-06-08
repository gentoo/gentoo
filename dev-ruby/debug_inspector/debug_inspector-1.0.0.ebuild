# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/debug_inspector/extconf.rb)

RUBY_FAKEGEM_GEMSPEC="debug_inspector.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A Ruby wrapper for the MRI 2.0 debug_inspector API"
HOMEPAGE="https://github.com/banister/debug_inspector"
SRC_URI="https://github.com/banister/debug_inspector/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/extensiontask/,$ s:^:#:' Rakefile || die
}
