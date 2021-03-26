# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Parallelized network login hacker"
HOMEPAGE="https://github.com/vanhauser-thc/thc-hydra"
SRC_URI="https://github.com/vanhauser-thc/thc-hydra/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="
	debug firebird gcrypt gtk idn libressl memcached mongodb mysql ncurses
	oracle pcre postgres rdp libssh subversion zlib
"

RDEPEND="
	gtk? (
		dev-libs/atk
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
	firebird? ( dev-db/firebird )
	gcrypt? ( dev-libs/libgcrypt )
	idn? ( net-dns/libidn:0= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	memcached? ( dev-libs/libmemcached[sasl] )
	mongodb? ( dev-libs/mongo-c-driver )
	mysql? ( dev-db/mysql-connector-c:0= )
	ncurses? ( sys-libs/ncurses:= )
	oracle? ( dev-db/oracle-instantclient-basic )
	pcre? ( dev-libs/libpcre )
	postgres? ( dev-db/postgresql:* )
	rdp? ( net-misc/freerdp )
	libssh? ( >=net-libs/libssh-0.4.0 )
	subversion? ( dev-vcs/subversion )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
S=${WORKDIR}/thc-${P}

src_prepare() {
	default

	# None of the settings in Makefile.unix are useful to us
	mv Makefile.unix{,.gentoo_unused} || die
	touch Makefile.unix || die

	sed -i \
		-e 's:|| echo.*$::' \
		-e '/\t-$(CC)/s:-::' \
		-e '/^OPTS/{s|=|+=|;s| -O3||}' \
		-e '/ -o /s:$(OPTS):& $(LDFLAGS):g' \
		Makefile.am || die
}

src_configure() {
	# Note: the top level configure script is not autoconf-based
	tc-export CC PKG_CONFIG

	append-cflags -fcommon

	export OPTS="${CFLAGS}"

	hydra_sed() {
		if use ${1}; then
			einfo "Enabling ${1}"
			if [[ -n "${3}" ]]; then
				sed -i 's#'"${2}"'#'"${3}"'#' configure || die
			fi
		else
			einfo "Disabling ${1}"
			sed -i 's#'"${2}"'##; s#'"${4}"'##' configure || die
		fi
	}

	hydra_sed firebird '-lfbclient' '' '-DLIBFIREBIRD'
	hydra_sed gcrypt '-lgcrypt' '$( ${CTARGET:-${CHOST}}-libgcrypt-config --libs )' '-DHAVE_GCRYPT'
	hydra_sed idn '-lidn' '$( "${PKG_CONFIG}" --libs libidn )' '-DLIBIDN -DHAVE_PR29_H'
	hydra_sed libssh '-lssh' '$( "${PKG_CONFIG}" --libs libssh )' '-DLIBSSH'
	hydra_sed memcached '-lmemcached' '$( "${PKG_CONFIG}" --libs libmemcached )' '-DLIBMCACHED'
	hydra_sed mongodb '-lmongoc-1.0' '$( "${PKG_CONFIG}" --libs libmongoc-1.0 )' '-DLIBMONGODB\|-DLIBBSON'
	hydra_sed mysql '-lmysqlclient' '$( ${CTARGET:-${CHOST}}-mysql_config --libs )' '-DLIBMYSQLCLIENT'
	hydra_sed ncurses '-lcurses' '$( "${PKG_CONFIG}" --libs ncurses )' '-DLIBNCURSES'
	hydra_sed pcre '-lpcre' '$( "${PKG_CONFIG}" --libs libpcre )' '-DHAVE_PCRE'
	hydra_sed postgres '-lpq' '$( "${PKG_CONFIG}" --libs libpq )' '-DLIBPOSTGRES'
	hydra_sed oracle '-locci -lclntsh' '' '-DLIBORACLE'
	hydra_sed rdp '-lfreerdp2' '$( "${PKG_CONFIG}" --libs freerdp2 )' '-DLIBFREERDP'
	# TODO: https://bugs.gentoo.org/686148
	#hydra_sed subversion '-lsvn_client-1 -lapr-1 -laprutil-1 -lsvn_subr-1' '$( "${PKG_CONFIG}" --libs libsvn_client )' '-DLIBSVN'
	hydra_sed subversion '-lsvn_client-1 -lapr-1 -laprutil-1 -lsvn_subr-1' '' '-DLIBSVN'
	hydra_sed zlib '-lz' '$( "${PKG_CONFIG}" --libs zlib )' '-DHAVE_ZLIB'

	sh configure \
		$(use gtk || echo --disable-xhydra) \
		$(usex debug '--debug' '') \
		--nostrip \
		--prefix=/usr \
		|| die

	if use gtk ; then
		pushd hydra-gtk || die
		econf
	fi
}

src_compile() {
	emake XLIBPATHS=''
	use gtk && emake -C hydra-gtk
}

src_install() {
	dobin hydra pw-inspector
	use gtk && dobin hydra-gtk/src/xhydra
	dodoc CHANGES README.md
}
