# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_4 )

inherit eutils python-single-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="provide (streaming) protocol decoding functionality"
HOMEPAGE="http://sigrok.org/wiki/Libsigrokdecode"

LICENSE="GPL-3"
SLOT="0/3"
IUSE="static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=dev-libs/glib-2.28.0
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf

	# Only a test program (not installed, and not used by src_test)
	# is used by libsigrok, so disable it to avoid the compile.
	sed -i \
		-e '/build_runtc=/s:yes:no:' \
		configure || die

	eapply_user
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	emake check
}

src_install() {
	default
	prune_libtool_files
}
