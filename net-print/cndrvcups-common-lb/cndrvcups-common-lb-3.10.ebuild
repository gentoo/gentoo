# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools multilib versionator

DESCRIPTION="Common files for Canon drivers"
HOMEPAGE="http://software.canon-europe.com/software/0046530.asp"
SRC_URI="http://files.canon-europe.com/files/soft46530/software/o1581en_linux_UFRII_v300.zip"

LICENSE="Canon-UFR-II GPL-2 MIT"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

# Needed because GPL2 stuff miss their sources in tarball
RESTRICT="mirror"

RDEPEND="
	dev-libs/libxml2
	gnome-base/libglade
	net-print/cups
	x11-libs/gtk+:2
"
DEPEND="${DEPEND}"

S="${WORKDIR}/uk_eng/Sources/${P}"

# Don't raise a fuss over pre-built binaries
QA_PREBUILT="
	/usr/libexec/cups/filter/c3pldrv
	/usr/$(get_abi_LIBDIR x86)/libColorGear.so.0.0.0
	/usr/$(get_abi_LIBDIR x86)/libColorGearC.so.0.0.0
	/usr/$(get_abi_LIBDIR x86)/libc3pl.so.0.0.1
	/usr/$(get_abi_LIBDIR x86)/libcaepcm.so.1.0
	/usr/$(get_abi_LIBDIR x86)/libcaiousb.so.1.0.0
	/usr/$(get_abi_LIBDIR x86)/libcaiowrap.so.1.0.0
	/usr/$(get_abi_LIBDIR x86)/libcanon_slim.so.1.0.0
	/usr/$(get_libdir)/libcanonc3pl.so.1.0.0
"
QA_SONAME="/usr/$(get_abi_LIBDIR x86)/libcaiousb.so.1.0.0"

S="${WORKDIR}/uk_eng/Sources/${P//-lb}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/uk_eng/Sources/"
	unpack ./${P//-lb}-1.tar.gz
}

change_dir() {
	for i in cngplp buftool backend; do
		cd "${i}"
		"${@}"
		cd "${S}"
	done
}

src_prepare() {
	sed -i -e \
		"s:backenddir = \$(libdir)/cups/backend:backenddir = `cups-config --serverbin`/backend:" \
		backend/Makefile.am || die

	export "LIBS=-lgmodule-2.0"
	change_dir eautoreconf
}

src_configure() {
	change_dir econf
}

src_compile() {
	change_dir emake

	# Cannot be moved to 'change_dir' as it doesn't need eautoreconf
	cd "${S}/c3plmod_ipc" && emake
}

src_install() {
	MAKEOPTS+=" -j1" default

	einstalldocs

	cd "${S}/c3plmod_ipc"
	dolib.so libcanonc3pl.so.1.0.0
	dosym libcanonc3pl.so.1.0.0 "/usr/$(get_libdir)/libcanonc3pl.so.1"
	dosym libcanonc3pl.so.1.0.0 "/usr/$(get_libdir)/libcanonc3pl.so"

	cd "${S}/data"
	insinto /usr/share/caepcm
	doins *

	ABI=x86
	cd "${S}/libs"
	exeinto $(cups-config --serverbin)/filter
	doexe c3pldrv
	dolib.so libcaepcm.so.1.0
	dosym libcaepcm.so.1.0 "/usr/$(get_libdir)/libcaepcm.so.1"
	dosym libcaepcm.so.1.0 "/usr/$(get_libdir)/libcaepcm.so"
	for lib in *.so.?.?.?; do
		dolib.so "${lib}"
		dosym "${lib}" "/usr/$(get_libdir)/${lib%.?.?}"
		dosym "${lib}" "/usr/$(get_libdir)/${lib%.?.?.?}"
	done

	# c3pldrv dlopens the absolute path /usr/lib/libc3pl.so :(
	if [[ "$(get_libdir)" != lib ]]; then
		dosym "../$(get_libdir)/libc3pl.so" /usr/lib/libc3pl.so
	fi
}
