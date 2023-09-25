# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} )
PYTHON_COMPAT=( python3_{9..11} )

inherit autotools lua-single perl-module python-single-r1 toolchain-funcs

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="https://rpm.org/ https://github.com/rpm-software-management/rpm"
SRC_URI="https://ftp.osuosl.org/pub/rpm/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2
	http://ftp.rpm.org/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

# Tests are broken. See bug #657500
RESTRICT="test"

IUSE="acl audit caps +berkdb doc dbus nls openmp python readline selinux +sqlite test +zstd"
REQUIRED_USE="${LUA_REQUIRED_USE}
	python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	${LUA_DEPS}
	!app-arch/rpm5
	app-arch/libarchive:=
	>=app-arch/bzip2-1.0.1
	app-arch/xz-utils
	>=app-crypt/gnupg-1.2
	>=dev-lang/perl-5.8.8
	dev-libs/elfutils
	dev-libs/libgcrypt:=
	>=dev-libs/popt-1.7
	sys-apps/file
	>=sys-libs/zlib-1.2.3-r1
	virtual/libintl
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	caps? ( >=sys-libs/libcap-2.0 )
	dbus? ( sys-apps/dbus )
	readline? ( sys-libs/readline:= )
	sqlite? ( dev-db/sqlite:3 )
	python? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	zstd? ( app-arch/zstd:= )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )
	test? ( sys-apps/fakechroot )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rpm )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.1-db-path.patch
	"${FILESDIR}"/${PN}-4.17.0-libdir.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	lua-single_pkg_setup

	use python && python-single-r1_pkg_setup

	# Added USE=openmp and this check for bug #779769
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	# bug #356769
	sed -i 's:%{_var}/tmp:/var/tmp:' macros.in || die "Fixing tmppath failed"
	# bug #492642
	sed -i "s:@__PYTHON@:${PYTHON}:" macros.in || die "Fixing %__python failed"

	# Prevent automake maintainer mode from kicking in (bug #450448).
	#touch -r Makefile.am preinstall.am || die

	eautoreconf
}

src_configure() {
	# rpm no longer supports berkdb, but has readonly support.
	# https://github.com/rpm-software-management/rpm/commit/4290300e24c5ab17c615b6108f38438e31eeb1d0
	econf \
		--enable-libelf \
		--without-selinux \
		--disable-inhibit-plugin \
		--with-crypto=libgcrypt \
		$(use_enable berkdb bdb-ro) \
		$(use_enable python) \
		$(use_enable nls) \
		$(use_enable openmp) \
		$(use_enable dbus inhibit-plugin) \
		$(use_enable sqlite) \
		$(use_with caps cap) \
		$(use_with acl) \
		$(use_with audit) \
		$(use_with readline) \
		$(use_enable zstd zstd $(usex zstd yes no))
}

src_test() {
	# Known to fail with FEATURES=usersandbox (bug #657500)
	if has usersandbox ${FEATURES} ; then
		ewarn "You are emerging ${P} with 'usersandbox' enabled." \
			"Expect some test failures or emerge with 'FEATURES=-usersandbox'!"
	fi

	emake check
}

src_install() {
	default

	# Remove la files
	find "${ED}" -name '*.la' -delete || die

	# Fix symlinks to /bin/rpm (bug #349840)
	for binary in rpmquery rpmverify; do
		ln -sf rpm "${ED}"/usr/bin/${binary} || die
	done

	if ! use nls; then
		rm -rf "${ED}"/usr/share/man/?? || die
	fi

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CREDITS README*
	if use doc; then
		local docname
		for docname in librpm; do
			docinto "html/${docname}"
			dodoc -r "docs/${docname}/html/."
		done
	fi

	# Fix perllocal.pod file collision
	perl_delete_localpod

	use python && python_optimize
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
