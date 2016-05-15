# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools multilib versionator

DESCRIPTION="Canon UFR II / LIPSLX Printer Driver for Linux"
HOMEPAGE="http://software.canon-europe.com/software/0046530.asp"
SRC_URI="http://files.canon-europe.com/files/soft46530/software/o1581en_linux_UFRII_v300.zip"

LICENSE="Canon-UFR-II"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

# Needed because GPL2 stuff miss their sources in tarball
RESTRICT="mirror"

RDEPEND="
	~net-print/cndrvcups-common-lb-3.10
	gnome-base/libglade
	net-print/cups
	x11-libs/gtk+:2
	>=dev-libs/libxml2-2.9.2-r4[abi_x86_32(-)]
	virtual/jpeg:62[abi_x86_32(-)]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/uk_eng/Sources/${P}"
MAKEOPTS+=" -j1"

# Don't raise a fuss over pre-built binaries
QA_PREBUILT="
	/usr/bin/cnpkbidi
	/usr/bin/cnpkmoduleufr2
	/usr/$(get_abi_LIBDIR x86)/libEnoJPEG.so.1.0.0
	/usr/$(get_abi_LIBDIR x86)/libEnoJBIG.so.1.0.0
	/usr/$(get_abi_LIBDIR x86)/libufr2filter.so.1.0.0
	/usr/$(get_abi_LIBDIR x86)/libcnlbcm.so.1.0
	/usr/$(get_abi_LIBDIR x86)/libcaiocnpkbidi.so.1.0.0
	/usr/$(get_abi_LIBDIR x86)/libcanonufr2.so.1.0.0
"
QA_SONAME="/usr/$(get_abi_LIBDIR x86)/libcaiocnpkbidi.so.1.0.0"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/uk_eng/Sources/"
	unpack ./${P}-1.tar.gz
}

change_dir() {
	for i in ppd pstoufr2cpca cngplp cngplp/files cpca ; do
		cd "${i}"
		"${@}"
		cd "${S}"
	done
}

src_prepare() {
	sed -i -e \
		"s:filterdir = \$(libdir)/cups/filter:filterdir = `cups-config --serverbin`/filter:" \
		pstoufr2cpca/filter/Makefile.am || die

	export "LIBS=-lgmodule-2.0"
	change_dir eautoreconf
}

src_configure() {
	change_dir econf
}

src_install() {
	default

	einstalldocs

	prune_libtool_files

	cd "${S}/data"
	insinto /usr/share/caepcm
	doins *

	cd "${S}/libs"
	insinto /usr/share/cnpkbidi
	doins cnpkbidi_info*

	insinto /usr/share/ufr2filter
	doins ThLB*

	ABI=x86
	dobin cnpkbidi cnpkmoduleufr2
	dolib.so libcnlbcm.so.1.0
	dosym libcnlbcm.so.1.0 "/usr/$(get_libdir)/libcnlbcm.so.1"
	dosym libcnlbcm.so.1.0 "/usr/$(get_libdir)/libcnlbcm.so"
	for lib in *.so.?.?.?; do
		dolib.so "${lib}"
		dosym "${lib}" "/usr/$(get_libdir)/${lib%.?.?}"
		dosym "${lib}" "/usr/$(get_libdir)/${lib%.?.?.?}"
	done

	# c3pldrv dlopens the absolute path /usr/lib/libcnlbcm.so :(
	if [[ "$(get_libdir)" != lib ]]; then
		dosym "../$(get_libdir)/libcnlbcm.so" /usr/lib/libcnlbcm.so
	fi
}
