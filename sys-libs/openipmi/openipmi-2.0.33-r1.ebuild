# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools python-single-r1

MY_PN="OpenIPMI"
MY_P="${MY_PN}-${PV/_/-}"
DESCRIPTION="Library interface to IPMI"
HOMEPAGE="https://sourceforge.net/projects/openipmi/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv x86"
IUSE="crypt snmp perl python static-libs tcl"

RDEPEND="
	dev-libs/glib:2
	dev-libs/popt
	sys-libs/gdbm:=
	sys-libs/ncurses:=
	sys-libs/readline:=
	crypt? ( dev-libs/openssl:= )
	snmp? ( net-analyzer/net-snmp )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/swig-1.3.21
	virtual/pkgconfig
"

# Gui is broken!
#		python? ( tcl? ( tk? ( dev-lang/tk dev-tcltk/tix ) ) )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.26-tinfo.patch" # bug #501510
	"${FILESDIR}/${PN}-2.0.33-c99.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# For tinfo patch
	eautoreconf
}

src_configure() {
	local myconf=(
		# These binaries are for root!
		--bindir="${EPREFIX}"/usr/sbin
		--with-glib
		--with-glibver=2.0
		--with-swig
		--without-tkinter
		$(use_with snmp ucdsnmp yes)
		$(use_with crypt openssl yes)
		$(use_with perl perl yes)
		$(use_with tcl tcl yes)
		$(use_with python python yes)
	)

	# GUI is broken
	#use tk && use python && use !tcl && \
	#	ewarn "Not building Tk GUI because it needs both Python AND Tcl"
	#if use python && use tcl; then
	#	myconf+=( $(use_with tk tkinter) )
	#else
	#	myconf+=( --without-tkinter )
	#fi

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README* FAQ ChangeLog TODO doc/IPMI.pdf lanserv/README.vm
	newdoc cmdlang/README README.cmdlang

	use python && python_optimize

	find "${ED}" -name "*.la" -delete || die

	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
