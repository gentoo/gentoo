# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="Library interface to IPMI"
HOMEPAGE="https://sourceforge.net/projects/openipmi/"
MY_PN="OpenIPMI"
MY_P="${MY_PN}-${PV/_/-}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~x86"
IUSE="crypt snmp perl python tcl"
S="${WORKDIR}/${MY_P}"
RESTRICT='test'

RDEPEND="
	dev-libs/glib:2
	sys-libs/gdbm:=
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	crypt? ( dev-libs/openssl:0= )
	snmp? ( net-analyzer/net-snmp )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.21
	virtual/pkgconfig"
# Gui is broken!
#		python? ( tcl? ( tk? ( dev-lang/tk dev-tcltk/tix ) ) )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	# https://bugs.gentoo.org/501510
	"${FILESDIR}/${PN}-2.0.26-tinfo.patch"

	"${FILESDIR}/${PN}-2.0.26-readline.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Bug #290763: The buildsys tries to compile+optimize the py file during
	# install, when the .so might not be been added yet. We just skip the files
	# and use python_optimize ourselves later instead.
	sed -r -i \
		-e '/INSTALL.*\.py[oc] /d' \
		-e '/install-exec-local/s,OpenIPMI.pyc OpenIPMI.pyo,,g' \
		swig/python/Makefile.{am,in}

	# Bug #298250: parallel install fix.
	sed -r -i \
		-e '/^install-data-local:/s,$, install-exec-am,g' \
		cmdlang/Makefile.{am,in}

	# We touch the .in and .am above because if we use the below, the Perl stuff
	# is very fragile, and often fails to link.
	#cd "${S}"
	eautoreconf
}

src_configure() {
	local myconf=(
		# these binaries are for root!
		--bindir=/usr/sbin
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
}
