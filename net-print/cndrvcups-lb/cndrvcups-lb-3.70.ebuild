# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="$(ver_rs 1- '')"
SOURCES_NAME="linux-UFRII-drv-v${MY_PV}-uken"

DESCRIPTION="Canon UFR II / LIPSLX Printer Driver for Linux"
HOMEPAGE="https://www.canon-europe.com/support/products/imagerunner/imagerunner-1730i.aspx"
SRC_URI="http://gdlp01.c-wss.com/gds/8/0100007658/08/${SOURCES_NAME}-05.tar.gz"
S="${WORKDIR}/${SOURCES_NAME}/Sources/${P}"

LICENSE="Canon-UFR-II"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/libxml2-2.9.1-r4[abi_x86_32(-)]
	>=gnome-base/libglade-2.4:2.0
	>=net-print/cups-1.1.17
	~net-print/cndrvcups-common-lb-${PV}
	>=x11-libs/gtk+-2.4:2
"
DEPEND="${RDEPEND}"

MAKEOPTS+=" -j1"

pkg_setup() {
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
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/${SOURCES_NAME}/Sources/" || die
	unpack ./${P}-1.tar.gz
}

change_dir() {
	for i in buftool pstoufr2cpca cngplp cngplp/files cpca ; do
		cd "${i}" || die
		"${@}" || die
		cd "${S}" || die
	done
}

src_prepare() {
	default
	sed -i -e \
		"s:filterdir = \$(libdir)/cups/filter:filterdir = `cups-config --serverbin`/filter:" \
		pstoufr2cpca/filter/Makefile.am || die

	export "LIBS=-lgmodule-2.0"
	change_dir mv configure.in configure.ac
	change_dir sed -i -e 's/configure.in/configure.ac/' configure.ac
	change_dir eautoreconf
}

src_configure() {
	change_dir econf
}

src_install() {
	default
	einstalldocs

	find "${ED}" -name '*.la' -type f -delete || die

	insinto /usr/share/cups/model
	doins ppd/*.ppd

	cd "${S}/data" || die
	insinto /usr/share/caepcm
	doins *

	cd "${S}/libs" || die
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

	# c3pldrv dlopens the absolute path /usr/lib/libcnlbcm.so :(, bug #????
	# Only needed with SYMLINK_LIB=yes #642138
	if [[ "$(get_libdir)" != lib ]] && [[ ${SYMLINK_LIB} = yes ]]; then
		dosym "../$(get_libdir)/libcnlbcm.so" /usr/lib/libcnlbcm.so
	fi
}
