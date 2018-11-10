# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="Advanced parallized login hacker"
HOMEPAGE="https://www.thc.org/thc-hydra/"
SRC_URI="
	https://github.com/vanhauser-thc/thc-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="firebird gtk idn libressl mysql ncp oracle pcre postgres ssl subversion"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/ncurses:=
	firebird? ( dev-db/firebird )
	gtk? (
		dev-libs/atk
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
	idn? ( net-dns/libidn )
	mysql? ( virtual/mysql )
	ncp? ( net-fs/ncpfs )
	oracle? ( dev-db/oracle-instantclient-basic )
	pcre? ( dev-libs/libpcre )
	postgres? ( dev-db/postgresql:* )
	ssl? ( >=net-libs/libssh-0.4.0 )
	subversion? ( dev-vcs/subversion )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-8.4-configure.patch
)
S=${WORKDIR}/thc-${P}

src_prepare() {
	default

	# None of the settings in Makefile.unix are useful to us
	: > Makefile.unix

	sed -i \
		-e 's:|| echo.*$::' \
		-e '/\t-$(CC)/s:-::' \
		-e '/^OPTS/{s|=|+=|;s| -O3||}' \
		-e '/ -o /s:$(OPTS):& $(LDFLAGS):g' \
		Makefile.am || die
}

src_configure() {
	export OPTS="${CFLAGS}"

	if ! use subversion; then
		sed -i 's/-lsvn_client-1 -lapr-1 -laprutil-1 -lsvn_subr-1//;s/-DLIBSVN//' configure || die
	fi

	if ! use mysql; then
		sed -i 's/-lmysqlclient//;s/-DLIBMYSQLCLIENT//' configure || die
	fi

	# Linking against libtinfo might be enough here but pkg-config --libs tinfo
	# would require a USE=tinfo flag and recent linkers should drop libcurses
	# as needed
	sed -i \
		-e 's|-lcurses|'"$( $(tc-getPKG_CONFIG) --libs ncurses)"'|g' \
		configure || die

	# Note: despite the naming convention, the top level script is not an
	# autoconf-based script.
	export NCP_PATH=$(usex ncp /usr/$(get_libdir) '')
	export NCP_IPATH=$(usex ncp /usr/include '')
	sh configure \
		--prefix=/usr \
		--nostrip \
		$(use gtk && echo --disable-xhydra) \
			|| die

	if use gtk ; then
		cd hydra-gtk && \
		econf
	fi
}

src_compile() {
	tc-export CC
	emake XLIBPATHS=''
	use gtk && emake -C hydra-gtk
}

src_install() {
	dobin hydra pw-inspector
	use gtk && dobin hydra-gtk/src/xhydra
	dodoc CHANGES README
}
