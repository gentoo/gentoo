# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fcaps multilib eutils toolchain-funcs flag-o-matic gnuconfig

MY_P="${P/_alpha/a}"

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://sourceforge.net/projects/cdrtools/"
SRC_URI="mirror://sourceforge/${PN}/$([[ -z ${PV/*_alpha*} ]] && echo 'alpha')/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CDDL-Schily"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="acl caps nls unicode"

RDEPEND="acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	nls? ( virtual/libintl )
	!app-cdr/cdrkit"
DEPEND="${RDEPEND}
	x11-misc/makedepend
	nls? ( >=sys-devel/gettext-0.18.1.1 )"

S=${WORKDIR}/${P/_alpha[0-9][0-9]}

FILECAPS=(
	cap_sys_resource,cap_dac_override,cap_sys_admin,cap_sys_nice,cap_net_bind_service,cap_ipc_lock,cap_sys_rawio+ep usr/bin/cdrecord --
	cap_dac_override,cap_sys_admin,cap_sys_nice,cap_net_bind_service,cap_sys_rawio+ep usr/bin/cdda2wav --
	cap_dac_override,cap_sys_admin,cap_net_bind_service,cap_sys_rawio+ep usr/bin/readcd
)

src_prepare() {
	gnuconfig_update

	# Remove profiled make files.
	find -name '*_p.mk' -delete

	# Adjusting hardcoded paths.
	sed -i -e 's:opt/schily:usr:' \
		$(find ./ -type f -name \*.[0-9ch] -exec grep -l 'opt/schily' '{}' '+') \
		|| die "sed opt/schily"

	sed -i -e "s:\(^INSDIR=\t\tshare/doc/\):\1${PF}/:" \
		$(find ./ -type f -exec grep -l 'INSDIR.\+doc' '{}' '+') \
		|| die "sed doc"

	# Respect libdir.
	sed -i -e "s:\(^INSDIR=\t\t\)lib:\1$(get_libdir):" \
		$(find ./ -type f -exec grep -l '^INSDIR.\+lib\(/siconv\)\?$' '{}' '+') \
		|| die "sed multilib"

	# Do not install static libraries.
	sed -i -e 's:include\t\t.*rules.lib::' \
		$(find ./ -type f -exec grep -l '^include.\+rules\.lib' '{}' '+') \
		|| die "sed rules"

	# Respect CC/CXX variables.
	cd "${S}"/RULES
	local tcCC=$(tc-getCC)
	local tcCXX=$(tc-getCXX)
	sed -i -e "/cc-config.sh/s|\$(C_ARCH:%64=%) \$(CCOM_DEF)|${tcCC} ${tcCC}|" \
		rules1.top || die "sed rules1.top"
	sed -i -e "/^\(CC\|DYNLD\|LDCC\|MKDEP\)/s|gcc|${tcCC}|" \
		-e "/^\(CC++\|DYNLDC++\|LDCC++\|MKC++DEP\)/s|g++|${tcCXX}|" \
		-e "/COPTOPT=/s/-O//" \
		-e 's/$(GCCOPTOPT)//' \
		cc-gcc.rul || die "sed cc-gcc.rul"
	sed -i -e "s|^#CONFFLAGS +=\t-cc=\$(XCC_COM)$|CONFFLAGS +=\t-cc=${tcCC}|g" \
		rules.cnf || die "sed rules.cnf"

	# Create additional symlinks needed for some archs (armv4l already created)
	local t
	for t in armv4tl armv5tel armv7l ppc64 s390x; do
		ln -s i586-linux-cc.rul ${t}-linux-cc.rul || die
		ln -s i586-linux-gcc.rul ${t}-linux-gcc.rul || die
	done

	# Schily make setup.
	cd "${S}"/DEFAULTS
	local os="linux"
	[[ ${CHOST} == *-darwin* ]] && os="mac-os10"

	sed -i \
		-e "s:/opt/schily:/usr:g" \
		-e "s:/usr/src/linux/include::g" \
		-e "s:bin:root:g" \
		-e '/^DEFUMASK/s,002,022,g' \
		Defaults.${os} || die "sed Schily make setup"
	# re DEFUMASK above:
	# bug 486680: grsec TPE will block the exec if the directory is
	# group-writable. This is painful with cdrtools, because it makes a bunch of
	# group-writable directories during build. Change the umask on their
	# creation to prevent this.
}

# skip obsolete configure script
src_configure() { : ; }

src_compile() {
	if use unicode; then
		local flags="$(test-flags -finput-charset=ISO-8859-1 -fexec-charset=UTF-8)"
		if [[ -n ${flags} ]]; then
			append-flags ${flags}
		else
			ewarn "Your compiler does not support the options required to build"
			ewarn "cdrtools with unicode in USE. unicode flag will be ignored."
		fi
	fi

	if ! use caps; then
		CFLAGS="${CFLAGS} -DNO_LINUX_CAPS"
	fi

	if ! use acl; then
		CFLAGS="${CFLAGS} -DNO_ACL"
	fi

	# If not built with -j1, "sometimes" cdda2wav will not be built.
	emake -j1 CC="$(tc-getCC)" CPPOPTX="${CPPFLAGS}" COPTX="${CFLAGS}" \
		LDOPTX="${LDFLAGS}" \
		INS_BASE="${ED}/usr" INS_RBASE="${ED}" LINKMODE="dynamic" \
		RUNPATH="" GMAKE_NOWARN="true"
}

src_install() {
	# If not built with -j1, "sometimes" manpages are not installed.
	emake -j1 CC="$(tc-getCC)" CPPOPTX="${CPPFLAGS}" COPTX="${CFLAGS}" \
		LDOPTX="${LDFLAGS}" \
		INS_BASE="${ED}/usr" INS_RBASE="${ED}" LINKMODE="dynamic" \
		RUNPATH="" GMAKE_NOWARN="true" install

	# These symlinks are for compat with cdrkit.
	dosym schily /usr/include/scsilib
	dosym ../scg /usr/include/schily/scg

	dodoc ABOUT Changelog* CONTRIBUTING PORTING README.linux-shm READMEs/README.linux

	cd "${S}"/cdda2wav
	docinto cdda2wav
	dodoc Changelog FAQ Frontends HOWTOUSE NEEDED README THANKS TODO

	cd "${S}"/mkisofs
	docinto mkisofs
	dodoc ChangeLog* TODO

	# Remove man pages related to the build system
	rm -rvf "${ED}"/usr/share/man/man5
}

pkg_postinst() {
	fcaps_pkg_postinst

	if [[ ${CHOST} == *-darwin* ]] ; then
		einfo
		einfo "Darwin/OS X use the following device names:"
		einfo
		einfo "CD burners: (probably) ./cdrecord dev=IOCompactDiscServices"
		einfo
		einfo "DVD burners: (probably) ./cdrecord dev=IODVDServices"
		einfo
	fi
}
