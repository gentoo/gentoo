# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info flag-o-matic

MY_PV=${PV/_/.}-3

DESCRIPTION="Device-mapper RAID tool and library"
HOMEPAGE="https://people.redhat.com/~heinzm/sw/dmraid/"
SRC_URI="https://people.redhat.com/~heinzm/sw/dmraid/src/${PN}-${MY_PV}.tar.bz2"
S="${WORKDIR}/${PN}/${MY_PV}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~ia64 ppc ppc64 ~sparc ~x86"
IUSE="intel_led led mini static"

RDEPEND=">=sys-fs/lvm2-2.02.45"
DEPEND="
	${RDEPEND}
	static? ( sys-fs/lvm2[static-libs] )
"
BDEPEND="
	app-arch/tar
	virtual/pkgconfig
"

pkg_setup() {
	if kernel_is lt 2 6 ; then
		ewarn "You are using a kernel < 2.6"
		ewarn "DMraid uses recently introduced Device-Mapper features."
		ewarn "These might be unavailable in the kernel you are running now."
	fi
}

src_prepare() {
	eapply -p2 "${FILESDIR}"/${P}-undo-p-rename.patch \
		"${FILESDIR}"/${P}-return-all-sets.patch
	eapply -p0 "${FILESDIR}"/${P}-static-build-fixes.patch
	eapply -p3 "${FILESDIR}"/${P}-parallel-make.patch
	eapply "${FILESDIR}"/${P}-fix-missing-PATH-MOUNTED.patch
	eapply "${FILESDIR}"/${PN}-1.0.0_rc16-musl.patch

	# pkg_check_modules is not in aclocal.m4 by default, and eautoreconf doesnt add it
	einfo "Appending pkg.m4 from system to aclocal.m4"
	cat "${BROOT}"/usr/share/aclocal/pkg.m4 >>"${S}"/aclocal.m4 || die "Could not append pkg.m4"

	mv configure.{in,ac} || die

	default

	eautoreconf

	einfo "Creating prepatched source archive for use with Genkernel"
	# archive the patched source for use with genkernel
	cd "${WORKDIR}" || die
	mkdir -p "tmp/${PN}" || die

	cp -a "${PN}/${MY_PV}/${PN}" "tmp/${PN}" || die
	mv "tmp/${PN}/${PN}" "tmp/${PN}/${MY_PV}" || die

	cd tmp || die
	tar -jcf ${PN}-${MY_PV}-prepatched.tar.bz2 ${PN} || die
	mv ${PN}-${MY_PV}-prepatched.tar.bz2 .. || die
}

src_configure() {
	# disable klibc and dietlibc, bug #653392
	econf \
		--with-usrlibdir='${prefix}'/$(get_libdir) \
		--disable-klibc \
		--disable-dietlibc \
		$(use_enable static static_link) \
		$(use_enable mini) \
		$(use_enable led) \
		$(use_enable intel_led)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc CHANGELOG README TODO KNOWN_BUGS doc/*

	insinto /usr/share/${PN}
	doins "${WORKDIR}"/${PN}-${MY_PV}-prepatched.tar.bz2
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "For booting Gentoo from Device-Mapper RAID you can use a Genkernel initramfs."
		elog
		elog "Genkernel will generate the kernel and the initramfs with a statically "
		elog "linked dmraid binary (its own version which may not be the same as this version):"
		elog "\t emerge -av sys-kernel/genkernel"
		elog "\t genkernel --dmraid all"
	fi
	# skip this message if this revision has already been emerged
	if [[ " ${REPLACING_VERSIONS} " != *\ ${PVR}\ * ]]; then
		elog
		elog "A pre-patched distfile of this version of DMRAID has been installed at"
		elog "/usr/share/${PN}/${PN}-${MY_PV}-prepatched.tar.bz2 , to support using it within a"
		elog "Genkernel initramfs."
		elog
	fi
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you would rather use this version of DMRAID with Genkernel, update the following"
		elog "in /etc/genkernel.conf:"
		elog "\t DMRAID_VER=\"${MY_PV}\""
		elog "\t DMRAID_SRCTAR=\"/usr/share/${PN}/${PN}-${MY_PV}-prepatched.tar.bz2\""
		elog
	fi
}
