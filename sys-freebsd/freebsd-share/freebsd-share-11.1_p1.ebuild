# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bsdmk freebsd

DESCRIPTION="FreeBSD shared tools/files"
SLOT="0"
LICENSE="BSD zfs? ( CDDL )"

IUSE="doc usb zfs"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~x86-fbsd"
fi

EXTRACTONLY="
	share/
	contrib/
	gnu/
	usr.bin/
	usr.sbin/
	sbin/
	bin/
	lib/
	etc/
	tools/tools/locale/
"

DEPEND="=sys-freebsd/freebsd-mk-defs-${RV}*
		=sys-freebsd/freebsd-sources-${RV}*"
RDEPEND="sys-apps/miscfiles"

RESTRICT="strip"

S="${WORKDIR}/share"

pkg_setup() {
	# Add the required source files.
	use zfs && EXTRACTONLY+="cddl/ "

	use doc || mymakeopts="${mymakeopts} WITHOUT_SHAREDOCS= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL= "

	has_version "<sys-freebsd/freebsd-ubin-10.1" && mymakeopts="${mymakeopts} WITHOUT_VT= "
	has_version "<sys-freebsd/freebsd-ubin-11.0" && mymakeopts="${mymakeopts} WITHOUT_LOCALES= "
	has_version "<sys-freebsd/freebsd-lib-9.1-r11" && mymakeopts="${mymakeopts} WITHOUT_ICONV= "

	mymakeopts="${mymakeopts} WITHOUT_SENDMAIL= WITHOUT_CLANG= "
}

REMOVE_SUBDIRS="mk termcap zoneinfo tabset"

PATCHES=(
	"${FILESDIR}/${PN}-10.3-gentoo-skel.patch"
	"${FILESDIR}/${PN}-10.0-gentoo-eapi3.patch"
	"${FILESDIR}/${PN}-10.2-gnu-miscfiles.patch"
	"${FILESDIR}/${PN}-SA-1808-tcp-11.patch"
	"${FILESDIR}/${PN}-SA-1810-ip.patch"
)

src_prepare() {
	# Remove make.conf manpage as it describes bsdmk's make.conf.
	sed -i -e 's:make.conf.5::' "${S}/man/man5/Makefile"
	# Remove rc.conf manpage as it describes bsd's rc.conf.
	sed -i -e 's:\brc.conf.5::' "${S}/man/man5/Makefile"
	sed -i -e 's:\brc.conf.local.5::' "${S}/man/man5/Makefile"
	# Remove mailer.conf manpage
	sed -i -e 's:mailer.conf.5::' "${S}/man/man5/Makefile"
	# Remove pbm and moduli(ssh) manpages
	sed -i -e 's:pbm.5::' -e 's:moduli.5::' "${S}/man/man5/Makefile"
	# Remove builtins manpage
	sed -i -e '/builtins\.1/d' "${S}/man/man1/Makefile"
	# Remove rc manpages
	sed -i -e '/rc.8/d' "${S}/man/man8/Makefile"
	# Remove hv_kvp_daemon.8 manpage. It's provided by freebsd-usbin.
	sed -i -e '/hv_kvp_daemon.8/d' "${S}/man/man8/Makefile"

	# Don't install the arch-specific directories in subdirectories
	sed -i -e '/MANSUBDIR/d' "${S}"/man/man4/man4.{i386,sparc64}/Makefile

	# Remove them so that they can't be included by error
	rm -rf "${S}"/mk/*.mk

	# Make proper symlinks by defining the full target.
	local sdir
	for sdir in colldef monetdef msgdef numericdef timedef
	do
		sed -e 's:\${enc2}$:\${enc2}/\${FILESNAME}:g' -i \
			"${S}/${sdir}/Makefile" || \
			die "Error fixing ${sdir}/Makefile"
	done
	if [[ ! -e "${WORKDIR}/sys" ]]; then
		ln -s "/usr/src/sys" "${WORKDIR}/sys" || die "failed to set sys symlink"
	fi
}

src_compile() {
	export ESED="/usr/bin/sed"

	# libiconv support.
	if ! has_version "<sys-freebsd/freebsd-lib-9.1-r11" ; then
		# i18n/csmapper/APPLE requires mkcsmapper_static
		# i18n/esdb/APPLE requires mkesdb_static
		for pkg in mkcsmapper_static mkesdb_static
		do
			cd "${WORKDIR}"/usr.bin/${pkg} || die
			freebsd_src_compile
		done
	fi

	# This is a groff problem and not a -shared problem.
	cd "${S}" || die
	export GROFF_TMAC_PATH="/usr/share/tmac/:/usr/share/groff/1.22.2/tmac/"
	freebsd_src_compile -j1 || die "emake failed"
}

src_install() {
	freebsd_src_install -j1 DOCDIR=/usr/share/doc/${PF}
}
