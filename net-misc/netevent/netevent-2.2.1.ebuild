# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool to share Linux event devices with other machines"
HOMEPAGE="https://github.com/Blub/netevent"
SRC_URI="https://github.com/Blub/netevent/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="doc"

BDEPEND="
	doc? ( dev-python/docutils )
"

src_configure() {
	tc-export CXX

	# Not Autoconf.
	RST2MAN=rst2man.py \
	./configure \
		--prefix="${EPREFIX}"/usr \
		$(use_enable doc) \
		|| die
}

src_compile() {
	emake CPPFLAGS="-Wall -Wno-unknown-pragmas"
}
