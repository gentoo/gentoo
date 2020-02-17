# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

COMMIT="c2066fa55db6f51090e00a240889d2f0cbd0ab4d"
DESCRIPTION="Tool to share Linux event devices with other machines"
HOMEPAGE="https://github.com/Blub/netevent"
SRC_URI="https://github.com/Blub/netevent/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="doc"

BDEPEND="
	doc? ( dev-python/docutils )
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	tc-export CXX

	# Not Autoconf.
	RST2MAN=rst2man.py \
	./configure \
		--prefix="${EPREFIX}"/usr \
		$(use_enable doc) \
		|| die
}
