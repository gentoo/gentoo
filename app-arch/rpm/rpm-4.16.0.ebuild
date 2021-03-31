# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-2 )
PYTHON_COMPAT=( python3_{7,8,9} )

inherit autotools flag-o-matic lua-single perl-module python-single-r1

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="https://rpm.org
	https://github.com/rpm-software-management/rpm"
SRC_URI="http://ftp.rpm.org/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 ~sparc x86 ~amd64-linux ~x86-linux"

# Tests are broken. See bug 657500
RESTRICT="test"

IUSE="acl caps doc dbus lua nls python selinux test +zstd"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="!app-arch/rpm5
	app-arch/libarchive
	>=sys-libs/db-4.5:*
	>=sys-libs/zlib-1.2.3-r1
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dbus? ( sys-apps/dbus )
	dev-libs/elfutils
	virtual/libintl
	>=dev-lang/perl-5.8.8
	dev-libs/nss
	python? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	lua? ( ${LUA_DEPS} )
	acl? ( virtual/acl )
	caps? ( >=sys-libs/libcap-2.0 )
	zstd? ( app-arch/zstd )
"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	test? ( sys-apps/fakechroot )
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-rpm )
"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}"/${P}-autotools.patch
	eapply "${FILESDIR}"/${PN}-4.8.1-db-path.patch
	eapply "${FILESDIR}"/${P}-libdir.patch

	# fix #356769
	sed -i 's:%{_var}/tmp:/var/tmp:' macros.in || die "Fixing tmppath failed"
	# fix #492642
	sed -i "s:@__PYTHON@:${PYTHON}:" macros.in || die "Fixing %__python failed"

	eapply_user

	eautoreconf

	# Prevent automake maintainer mode from kicking in (#450448).
	touch -r Makefile.am preinstall.am
}

src_configure() {
	append-cppflags -I"${EPREFIX}/usr/include/nss" -I"${EPREFIX}/usr/include/nspr"
	econf \
		--without-selinux \
		--with-crypto=nss \
		$(use_enable python) \
		$(use_enable nls) \
		$(use_enable dbus inhibit-plugin) \
		$(use_with lua) \
		$(use_with caps cap) \
		$(use_with acl) \
		$(use_enable zstd zstd $(usex zstd yes no))
}

src_install() {
	default

	# remove la files
	find "${ED}" -name '*.la' -delete || die

	# fix symlinks to /bin/rpm (#349840)
	for binary in rpmquery rpmverify;do
		ln -sf rpm "${ED}"/usr/bin/${binary} || die
	done

	if ! use nls; then
		rm -rf "${ED}"/usr/share/man/?? || die
	fi

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CREDITS README*
	if use doc; then
		for docname in librpm; do
			docinto "html/${docname}"
			dodoc -r "doc/${docname}/html/."
		done
	fi

	# Fix perllocal.pod file collision
	perl_delete_localpod

	use python && python_optimize
}

src_test() {
	# Known to fail with FEATURES=usersandbox (bug #657500):
	if has usersandbox $FEATURES ; then
		ewarn "You are emerging ${P} with 'usersandbox' enabled." \
			"Expect some test failures or emerge with 'FEATURES=-usersandbox'!"
	fi

	emake check
}

pkg_postinst() {
	if [[ -f "${EROOT}"/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${EROOT}"/usr/bin/rpmdb --rebuilddb --root="${EROOT}/" || die
	else
		einfo "No RPM database found... Creating database..."
		"${EROOT}"/usr/bin/rpmdb --initdb --root="${EROOT}/" || die
	fi
}
