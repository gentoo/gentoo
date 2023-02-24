# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} != 3.2.4 ]]; then
	# Make sure we revert the autotools hackery applied in 3.2.4.
	die "Please use rsync-9999.ebuild as a basis for version bumps"
fi

WANT_LIBTOOL=none

PYTHON_COMPAT=( python3_{9..10} )
inherit autotools flag-o-matic prefix python-single-r1 systemd

DESCRIPTION="File transfer program to keep remote files into sync"
HOMEPAGE="https://rsync.samba.org/"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/WayneD/rsync.git"
	inherit autotools git-r3

	REQUIRED_USE="${PYTHON_REQUIRED_USE}"
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/waynedavison.asc
	inherit verify-sig

	if [[ ${PV} == *_pre* ]] ; then
		SRC_DIR="src-previews"
	else
		SRC_DIR="src"
		KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	fi

	SRC_URI="https://rsync.samba.org/ftp/rsync/${SRC_DIR}/${P/_/}.tar.gz
		verify-sig? ( https://rsync.samba.org/ftp/rsync/${SRC_DIR}/${P/_/}.tar.gz.asc )"
	S="${WORKDIR}"/${P/_/}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="acl examples iconv ipv6 lz4 ssl stunnel system-zlib xattr xxhash zstd"
REQUIRED_USE+=" examples? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="acl? ( virtual/acl )
	examples? (
		${PYTHON_DEPS}
		dev-lang/perl
	)
	lz4? ( app-arch/lz4 )
	ssl? ( dev-libs/openssl:0= )
	system-zlib? ( sys-libs/zlib )
	xattr? ( kernel_linux? ( sys-apps/attr ) )
	xxhash? ( dev-libs/xxhash )
	zstd? ( >=app-arch/zstd-1.4 )
	>=dev-libs/popt-1.5
	iconv? ( virtual/libiconv )"
DEPEND="${RDEPEND}"
BDEPEND="examples? ( ${PYTHON_DEPS} )"

if [[ ${PV} == *9999 ]] ; then
	BDEPEND+=" ${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/commonmark[${PYTHON_USEDEP}]
		')"
else
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-waynedavison )"
fi

PATCHES=(
	"${FILESDIR}"/${P}-unsigned-char-checksum.patch
	# https://github.com/WayneD/rsync/issues/324
	"${FILESDIR}"/${P}-strlcpy.patch
	"${FILESDIR}"/${P}-notpedantic.patch
)

pkg_setup() {
	# - USE=examples needs Python itself at runtime, but nothing else
	# - 9999 needs commonmark at build time
	if [[ ${PV} == *9999 ]] || use examples ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	default

	eautoconf -o configure.sh
	eautoheader && touch config.h.in
}

src_configure() {
	# Force enable IPv6 on musl - upstream bug:
	# https://bugzilla.samba.org/show_bug.cgi?id=10715
	use elibc_musl && use ipv6 && append-cppflags -DINET6

	local myeconfargs=(
		--with-rsyncd-conf="${EPREFIX}"/etc/rsyncd.conf
		--without-included-popt
		$(use_enable acl acl-support)
		$(use_enable iconv)
		$(use_enable ipv6)
		$(use_enable lz4)
		$(use_enable ssl openssl)
		$(use_with !system-zlib included-zlib)
		$(use_enable xattr xattr-support)
		$(use_enable xxhash)
		$(use_enable zstd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	newconfd "${FILESDIR}"/rsyncd.conf.d rsyncd
	newinitd "${FILESDIR}"/rsyncd.init.d-r1 rsyncd

	dodoc NEWS.md README.md TODO tech_report.tex

	insinto /etc
	newins "${FILESDIR}"/rsyncd.conf-3.0.9-r1 rsyncd.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/rsyncd.logrotate rsyncd

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/rsyncd.xinetd-3.0.9-r1 rsyncd

	# Install stunnel helpers
	if use stunnel ; then
		emake DESTDIR="${D}" install-ssl-daemon
	fi

	# Install the useful contrib scripts
	if use examples ; then
		python_fix_shebang support/

		exeinto /usr/share/rsync
		doexe support/*

		rm -f "${ED}"/usr/share/rsync/{Makefile*,*.c}
	fi

	eprefixify "${ED}"/etc/{,xinetd.d}/rsyncd*

	systemd_newunit packaging/systemd/rsync.service rsyncd.service
}

pkg_postinst() {
	if grep -Eqis '^[[:space:]]use chroot[[:space:]]*=[[:space:]]*(no|0|false)' \
		"${EROOT}"/etc/rsyncd.conf "${EROOT}"/etc/rsync/rsyncd.conf ; then
		ewarn "You have disabled chroot support in your rsyncd.conf.  This"
		ewarn "is a security risk which you should fix.  Please check your"
		ewarn "/etc/rsyncd.conf file and fix the setting 'use chroot'."
	fi

	if use stunnel ; then
		einfo "Please install \">=net-misc/stunnel-4\" in order to use stunnel feature."
		einfo
		einfo "You maybe have to update the certificates configured in"
		einfo "${EROOT}/etc/stunnel/rsync.conf"
	fi

	if use system-zlib ; then
		ewarn "Using system-zlib is incompatible with <rsync-3.1.1 when"
		ewarn "using the --compress option."
		ewarn
		ewarn "When syncing with >=rsync-3.1.1 built with bundled zlib,"
		ewarn "and the --compress option, add --new-compress (-zz)."
		ewarn
		ewarn "For syncing the portage tree, add:"
		ewarn "PORTAGE_RSYNC_EXTRA_OPTS=\"--new-compress\" to make.conf"
	fi
}
