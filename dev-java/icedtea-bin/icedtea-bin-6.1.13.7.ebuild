# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-vm-2 prefix versionator

dist="http://dev.gentoo.org/~chewi/distfiles"
TARBALL_VERSION="${PV}"

DESCRIPTION="A Gentoo-made binary build of the IcedTea JDK"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="doc? ( ${dist}/${PN}-doc-${TARBALL_VERSION}.tar.xz )
	source? ( ${dist}/${PN}-src-${TARBALL_VERSION}.tar.xz )"

for arch in amd64 ppc x86; do
	SRC_URI+="
		${arch}? (
			${dist}/${PN}-core-${TARBALL_VERSION}-${arch}.tar.xz
			examples? ( ${dist}/${PN}-examples-${TARBALL_VERSION}-${arch}.tar.xz )
		)"
done

LICENSE="GPL-2-with-linking-exception"
SLOT="6"
KEYWORDS="-* amd64 ppc x86"

IUSE="+X +alsa cjk +cups doc examples nsplugin selinux source webstart"
REQUIRED_USE="nsplugin? ( X )"
RESTRICT="strip"

# 423161
QA_PREBUILT="opt/.*"

ALSA_COMMON_DEP="
	>=media-libs/alsa-lib-1.0"
CUPS_COMMON_DEP="
	>=net-print/cups-2.0"
X_COMMON_DEP="
	>=media-libs/freetype-2.5:2
	>=x11-libs/gtk+-2.24:2
	>=x11-libs/libX11-1.6
	>=x11-libs/libXext-1.3
	>=x11-libs/libXi-1.7
	>=x11-libs/libXrender-0.9.4
	>=x11-libs/libXtst-1.2"

COMMON_DEP="
	>=media-libs/giflib-4.1.6-r1
	>=media-libs/lcms-2.6:2
	media-libs/libpng:0/16
	>=sys-devel/gcc-4.8.4
	>=sys-libs/glibc-2.20
	>=sys-libs/zlib-1.2.3-r1
	virtual/jpeg:62"

RDEPEND="${COMMON_DEP}
	X? (
		${X_COMMON_DEP}
		media-fonts/dejavu
		cjk? (
			media-fonts/arphicfonts
			media-fonts/baekmuk-fonts
			media-fonts/lklug
			media-fonts/lohit-fonts
			media-fonts/sazanami
		)
	)
	alsa? ( ${ALSA_COMMON_DEP} )
	cups? ( ${CUPS_COMMON_DEP} )
	selinux? ( sec-policy/selinux-java )"

PDEPEND="webstart? ( dev-java/icedtea-web:0 )
	nsplugin? ( dev-java/icedtea-web:0[nsplugin] )"

src_prepare() {
	# Ensures HeadlessGraphicsEnvironment is used.
	if ! use X; then
		rm -r jre/lib/$(get_system_arch)/xawt || die
	fi

	# Reprefixify because prefix may be different.
	sed -i 's:=/:=@GENTOO_PORTAGE_EPREFIX@/:' jre/lib/fontconfig.Gentoo.properties || die
	eprefixify jre/lib/fontconfig.Gentoo.properties
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"
	dodir "${dest}"

	# doins doesn't preserve executable bits.
	cp -pRP bin include jre lib man "${ddest}" || die

	dodoc doc/{ASSEMBLY_EXCEPTION,AUTHORS,NEWS,README,THIRD_PARTY_README}
	use doc && dodoc -r doc/html

	if use examples; then
		cp -pRP demo sample "${ddest}" || die
	fi

	if use source; then
		cp src.zip "${ddest}" || die
	fi

	if use webstart || use nsplugin; then
		dosym /usr/libexec/icedtea-web/itweb-settings "${dest}/bin/itweb-settings"
		dosym /usr/libexec/icedtea-web/itweb-settings "${dest}/jre/bin/itweb-settings"
	fi
	if use webstart; then
		dosym /usr/libexec/icedtea-web/javaws "${dest}/bin/javaws"
		dosym /usr/libexec/icedtea-web/javaws "${dest}/jre/bin/javaws"
	fi

	set_java_env
	java-vm_revdep-mask "${dest}"
	java-vm_sandbox-predict /proc/self/coredump_filter
}

pkg_preinst() {
	if has_version "<=dev-java/icedtea-bin-1.10.4:${SLOT}"; then
		# portage would preserve the symlink otherwise, related to bug #384397
		rm -f "${EROOT}/usr/lib/jvm/icedtea6-bin"
		elog "To unify the layout and simplify scripts, the identifier of Icedtea-bin-6*"
		elog "has changed from 'icedtea6-bin' to 'icedtea-bin-6' starting from version 6.1.10.4"
		elog "If you had icedtea6-bin as system VM, the change should be automatic, however"
		elog "build VM settings in /etc/java-config-2/build/jdk.conf are not changed"
		elog "and the same holds for any user VM settings. Sorry for the inconvenience."
	fi
}

pkg_postinst() {
	if use nsplugin; then
		if [[ -n ${REPLACING_VERSIONS} ]] && ! version_is_at_least 6.1.13.3-r1 ${REPLACING_VERSIONS} ]]; then
			elog "The nsplugin for icedtea-bin is now provided by the icedtea-web package"
			elog "If you had icedtea-bin-6 nsplugin selected, you may see a related error below"
			elog "The switch should complete properly during the subsequent installation of icedtea-web"
			elog "Afterwards you may verify the output of 'eselect java-nsplugin list' and adjust accordingly'"
		fi
	fi

	# Set as default VM if none exists
	java-vm-2_pkg_postinst
}
