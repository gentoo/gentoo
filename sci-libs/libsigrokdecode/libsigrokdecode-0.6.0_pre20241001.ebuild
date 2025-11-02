# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit autotools python-single-r1

case ${PV} in
*9999*)
	EGIT_REPO_URI="https://github.com/sigrokproject/${PN}.git"
	inherit git-r3
	S="${WORKDIR}"/${P}
	;;
*_p*)
	inherit unpacker
	COMMIT="71f451443029322d57376214c330b518efd84f88"
	SRC_URI="https://sigrok.org/gitweb/?p=${PN}.git;a=snapshot;h=${COMMIT};sf=zip -> ${PN}-${COMMIT:0:7}.zip"
	S="${WORKDIR}"/${PN}-${COMMIT:0:7}
	;;
*)
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	S="${WORKDIR}"/${P}
	;;
esac

DESCRIPTION="Provide (streaming) protocol decoding functionality"
HOMEPAGE="https://sigrok.org/wiki/Libsigrokdecode"

LICENSE="GPL-3"
if [[ ${PV} == *9999* ]]; then
	SLOT="0/9999"
else
	SLOT="0/4"
	KEYWORDS="~amd64 ~x86"
fi
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.34.0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
[[ ${PV} == *_p* ]] && BDEPEND+=" app-arch/unzip"

src_unpack() {
	case ${PV} in
	*9999*)
		git-r3_src_unpack ;;
	*_p*)
		unpack_zip ${A} ;;
	esac
	default
}

src_prepare() {
	default

	# bug #794592
	sed -e "s/\[SRD_PKGLIBS\],\$/& [python-${EPYTHON#python}-embed], [python-${EPYTHON#python}],/" \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	econf PYTHON3="${PYTHON}"
}

src_test() {
	emake check
}

src_install() {
	default
	python_optimize "${D}"/usr/share/libsigrokdecode/decoders
	find "${D}" -name '*.la' -type f -delete || die
}
