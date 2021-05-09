# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# emacs support disabled due to #99533 #335900

EAPI=7

inherit autotools linux-info systemd usr-ldscript multilib-minimal

DESCRIPTION="Console-based mouse driver"
HOMEPAGE="https://www.nico.schottelius.org/software/gpm/"
SRC_URI="
	https://www.nico.schottelius.org/software/${PN}/archives/${P}.tar.lzma
	mirror://gentoo/${P}-docs.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="selinux"

RDEPEND="
	sys-libs/ncurses:=[${MULTILIB_USEDEP}]
	selinux? ( sec-policy/selinux-gpm )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-apps/texinfo
	virtual/yacc"

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

	eapply_user

	# fix ABI values
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
	gen_usr_ldscript -a gpm
}

multilib_src_install_all() {
	insinto /etc/gpm
	doins conf/gpm-*.conf

	dodoc README TODO doc/Announce doc/FAQ doc/README*

	newinitd "${FILESDIR}"/gpm.rc6-2 gpm
	newconfd "${FILESDIR}"/gpm.conf.d gpm
	systemd_dounit "${FILESDIR}"/gpm.service
}
