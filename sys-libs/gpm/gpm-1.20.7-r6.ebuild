# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-info systemd multilib-minimal

DESCRIPTION="Console-based mouse driver"
HOMEPAGE="https://www.nico.schottelius.org/software/gpm/"
SRC_URI="
	https://www.nico.schottelius.org/software/${PN}/archives/${P}.tar.lzma
	mirror://gentoo/${P}-docs.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="selinux"

RDEPEND="
	sys-libs/ncurses:=[${MULTILIB_USEDEP}]
	selinux? ( sec-policy/selinux-gpm )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-apps/texinfo
	app-alternatives/yacc"

CONFIG_CHECK="~INPUT_MOUSEDEV"
ERROR_INPUT_MOUSEDEV="CONFIG_INPUT_MOUSEDEV:\tis not set (required to expose mice for GPM)"

pkg_pretend() {
	check_extra_config
}

src_prepare() {
	eapply "${FILESDIR}"/${P}-sysmacros.patch

	# Hack up the docs until we get this sorted upstream.
	# https://github.com/telmich/gpm/issues/8
	eapply "${WORKDIR}"/${P}-docs.patch
	touch -r . doc/* || die

	# bug #629774
	eapply "${FILESDIR}"/${P}-glibc-2.26.patch
	# bug #705878
	eapply "${FILESDIR}"/${P}-gcc-10.patch
	# bug #829581
	eapply "${FILESDIR}"/${P}-musl.patch
	#
	eapply "${FILESDIR}"/${P}-gcc-include.patch
	eapply "${FILESDIR}"/${P}-signedness.patch
	eapply "${FILESDIR}"/${P}-warnings.patch

	eapply_user

	# Fix ABI values
	sed -i \
		-e '/^abi_lev=/s:=.*:=1:' \
		-e '/^abi_age=/s:=.*:=20:' \
		configure.ac.footer || die
	# Rebuild autotools since release doesn't include them.
	# Should be fixed with the next release though.
	# https://github.com/telmich/gpm/pull/15
	sed -i -e '/ACLOCAL/,$d' autogen.sh || die
	./autogen.sh
	eautoreconf

	# Out-of-tree builds are broken.
	# https://github.com/telmich/gpm/issues/16
	multilib_copy_sources
}

multilib_src_configure() {
	# bug #885323
	# src/headers/daemon.h:175:25: error: type of ‘cinfo’ does not match original declaration [-Werror=lto-type-mismatch]
	filter-lto

	# emacs support disabled due to bug #99533, bug #335900
	econf \
		--disable-static \
		--sysconfdir="${EPREFIX}"/etc/gpm \
		emacs="${BROOT}"/bin/false
}

_emake() {
	emake \
		EMACS=: ELISP="" \
		$(multilib_is_native_abi || echo "PROG= ") \
		"$@"
}

multilib_src_compile() {
	_emake
}

multilib_src_test() {
	_emake check
}

multilib_src_install() {
	_emake DESTDIR="${D}" install

	dosym libgpm.so.1 /usr/$(get_libdir)/libgpm.so
}

multilib_src_install_all() {
	insinto /etc/gpm
	doins conf/gpm-*.conf

	dodoc README TODO doc/Announce doc/FAQ doc/README*

	newinitd "${FILESDIR}"/gpm.rc6-2 gpm
	newconfd "${FILESDIR}"/gpm.conf.d gpm
	systemd_newunit "${FILESDIR}"/gpm.service-r1 gpm.service
}
