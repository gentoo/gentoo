# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bsdmk freebsd

DESCRIPTION="FreeBSD shared tools/files"
SLOT="0"

IUSE="doc zfs"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
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
"
use zfs && EXTRACTONLY+="cddl/"

DEPEND="=sys-freebsd/freebsd-mk-defs-${RV}*
		=sys-freebsd/freebsd-sources-${RV}*"
RDEPEND="sys-apps/miscfiles"

RESTRICT="strip"

S="${WORKDIR}/share"

pkg_setup() {
	use doc || mymakeopts="${mymakeopts} NO_SHAREDOCS= "
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL= "
	[[ ! -e /usr/bin/vtfontcvt ]] && mymakeopts="${mymakeopts} WITHOUT_VT= "

	mymakeopts="${mymakeopts} NO_SENDMAIL= NO_MANCOMPRESS= NO_INFOCOMPRESS= "
}

REMOVE_SUBDIRS="mk termcap zoneinfo tabset"

PATCHES=( "${FILESDIR}/${PN}-5.3-doc-locations.patch"
	"${FILESDIR}/${PN}-5.4-gentoo-skel.patch"
	"${FILESDIR}/${PN}-9.2-gnu-miscfiles.patch"
	"${FILESDIR}/${PN}-10.0-gentoo-eapi3.patch" )

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
	for sdir in colldef mklocale monetdef msgdef numericdef timedef
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
	# i18n/csmapper/APPLE requires mkcsmapper_static
	# i18n/esdb/APPLE requires mkesdb_static
	for pkg in mkcsmapper_static mkesdb_static
	do
		cd "${WORKDIR}"/usr.bin/${pkg}
		freebsd_src_compile
	done

	# This is a groff problem and not a -shared problem.
	cd "${S}"
	export GROFF_TMAC_PATH="/usr/share/tmac/:/usr/share/groff/1.22.2/tmac/"
	freebsd_src_compile -j1 || die "emake failed"
}

src_install() {
	mkmake -j1 DESTDIR="${D}" DOCDIR=/usr/share/doc/${PF} install || die "Install failed"
}
