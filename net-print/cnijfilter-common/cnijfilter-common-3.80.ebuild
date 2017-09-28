# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="cnijfilter-source-${PV}-1"

DESCRIPTION="CUPS drivers for Canon Pixma inkjet printers (common part)"
HOMEPAGE="https://wiki.gentoo.org/wiki/Canon_Pixma_Printer"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0100004693/01/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+net +servicetools"

RDEPEND="
	>=media-libs/libpng-1.5:0=
	>=media-libs/tiff-3.4:0=
	>=net-print/cups-1.4
	servicetools? (
		>=dev-libs/libxml2-2.7.3-r2
		>=x11-libs/gtk+-2.6:2
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S="${WORKDIR}/${MY_P}"

# Patches from bug #130645

PATCHES=(
	"${FILESDIR}/cnijfilter-3.70-png.patch"
	"${FILESDIR}/cnijfilter-3.70-ppd.patch"
	"${FILESDIR}/cnijfilter-3.70-ppd2.patch"
	"${FILESDIR}/cnijfilter-3.70-libexec-cups.patch"
	"${FILESDIR}/cnijfilter-3.70-libexec-backend.patch"
	"${FILESDIR}/cnijfilter-3.80-cups1.6.patch"
	)

pkg_setup() {
	[[ -z ${LINGUAS} ]] && LINGUAS="en"

	if [[ ${MERGE_TYPE} != binary ]]; then
		DIRS=(libs pstocanonij backend)
		use net && DIRS+=(backendnet)
		use servicetools && DIRS+=(cngpij)
	fi
}

src_prepare() {
	# apply patches
	default

	local d
	for d in "${DIRS[@]}"; do
		pushd "${d}" >/dev/null || die
		eautoreconf
		popd >/dev/null || die
	done
}

src_configure() {
	local d
	for d in "${DIRS[@]}"; do
		pushd "${d}" >/dev/null || die
		# progpath must be set otherwise defaulted to /usr/local/bin
		econf --enable-progpath="${EPREFIX}/usr/bin"
		popd >/dev/null || die
	done
}

src_compile() {
	local d
	for d in "${DIRS[@]}"; do
		emake -C "${d}"
	done
}

src_install() {
	local d
	for d in "${DIRS[@]}"; do
		emake -C "${d}" DESTDIR="${D}" install
	done

	if use net; then
		pushd com/libs_bin$(usex amd64 64 32) >/dev/null || die
		dolib.so libcnnet.so*
		popd >/dev/null || die
	fi
}
