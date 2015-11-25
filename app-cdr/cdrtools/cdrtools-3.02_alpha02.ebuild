# Copyright 1999-2015 Gentoo Foundation
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
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

cdrtools_os() {
	local os="linux"
	[[ ${CHOST} == *-darwin* ]] && os="mac-os10"
	[[ ${CHOST} == *-freebsd* ]] && os="freebsd"
	echo "${os}"
}

src_prepare() {
	gnuconfig_update

	# Remove profiled make files.
	find -name '*_p.mk' -delete

	# Adjusting hardcoded paths.
	sed -i -e "s|opt/schily|usr|" \
		$(find ./ -type f -name \*.[0-9ch] -exec grep -l 'opt/schily' '{}' '+') \
		|| die "sed opt/schily"

	sed -i -e "s|\(^INSDIR=\t\tshare/doc/\)|\1${PF}/|" \
		$(find ./ -type f -exec grep -l '^INSDIR.\+doc' '{}' '+') \
		|| die "sed doc"

	# Respect libdir.
	sed -i -e "s|\(^INSDIR=\t\t\)lib|\1$(get_libdir)|" \
		$(find ./ -type f -exec grep -l '^INSDIR.\+lib\(/siconv\)\?$' '{}' '+') \
		|| die "sed multilib"

	# Do not install static libraries.
	sed -i -e "s|include\t\t.*rules.lib||" \
		$(find ./ -type f -exec grep -l '^include.\+rules\.lib' '{}' '+') \
		|| die "sed rules"

	# Enable verbose build.
	sed -i -e '/@echo.*==>.*;/s:@echo[^;]*;:&set -x;:' \
		RULES/*.rul RULES/rules.prg RULES/rules.inc \
		|| die "sed verbose rules"

	# Respect CC/CXX variables.
	cd "${S}"/RULES
	local tcCC=$(tc-getCC)
	local tcCXX=$(tc-getCXX)
	sed -i -e "/cc-config.sh/s|\$(C_ARCH:%64=%) \$(CCOM_DEF)|${tcCC} ${tcCC}|" \
		rules1.top || die "sed rules1.top"
	sed -i -e "/^CC_COM_DEF=/s|gcc|${tcCC}|" \
		-e "/^CC++_COM_DEF=/s|g++|${tcCXX}|" \
		-e "/COPTOPT=/s|-O||" \
		-e 's|$(GCCOPTOPT)||' \
		cc-gcc.rul || die "sed cc-gcc.rul"
	sed -i -e "s|^#\(CONFFLAGS +=\).*|\1\t-cc=${tcCC}|" \
		rules.cnf || die "sed rules.cnf"

	# Schily make setup.
	cd "${S}"/DEFAULTS
	local os=$(cdrtools_os)

	sed -i \
		-e "s|^\(DEFLINKMODE=\).*|\1\tdynamic|" \
		-e "s|^\(LINUX_INCL_PATH=\).*|\1|" \
		-e "s|^\(LDPATH=\).*|\1|" \
		-e "s|^\(RUNPATH=\).*|\1|" \
		-e "s|^\(INS_BASE=\).*|\1\t${ED}/usr|" \
		-e "s|^\(INS_RBASE=\).*|\1\t${ED}|" \
		-e "s|^\(DEFINSGRP=\).*|\1\t0|" \
		-e '/^DEFUMASK/s,002,022,g' \
		Defaults.${os} || die "sed Schily make setup"
	# re DEFUMASK above:
	# bug 486680: grsec TPE will block the exec if the directory is
	# group-writable. This is painful with cdrtools, because it makes a bunch of
	# group-writable directories during build. Change the umask on their
	# creation to prevent this.
}

ac_cv_sizeof() {
	cat <<-EOF >"${T}"/test.c
	#include <inttypes.h>
	#include <stddef.h>
	#include <stdint.h>
	#include <sys/types.h>
	int main () {
		static int test_array [1 - 2 * !((sizeof(TYPE)) == LEN)];
		test_array [0] = 0;
		return test_array [0];
	}
	EOF

	local i=1
	while [[ ${i} -lt 20 ]] ; do
		if ${CC} ${CPPFLAGS} ${CFLAGS} -c "${T}"/test.c -o /dev/null -DTYPE="$1" -DLEN=$i 2>/dev/null; then
			echo ${i}
			return 0
		fi
		: $(( i += 1 ))
	done
	return 1
}

src_configure() {
	use acl || export ac_cv_header_sys_acl_h="no"
	use caps || export ac_cv_lib_cap_cap_get_proc="no"

	# skip obsolete configure script
	if tc-is-cross-compiler ; then
		# Cache known values for targets. #486680

		tc-export CC
		local var val t types=(
			char "short int" int "long int" "long long"
			"unsigned char" "unsigned short int" "unsigned int"
			"unsigned long int" "unsigned long long"
			float double "long double" size_t ssize_t ptrdiff_t
			mode_t uid_t gid_t pid_t dev_t time_t wchar_t
			"char *" "unsigned char *"
		)
		for t in "${types[@]}" ; do
			var="ac_cv_sizeof_${t// /_}"
			var=${var//[*]/p}
			val=$(ac_cv_sizeof "${t}") || die "could not compute ${t}"
			export "${var}=${val}"
			einfo "Computing sizeof(${t}) as ${val}"
		done
		# We don't have these types.
		export ac_cv_sizeof___int64=0
		export ac_cv_sizeof_unsigned___int64=0
		export ac_cv_sizeof_major_t=${ac_cv_sizeof_dev_t}
		export ac_cv_sizeof_minor_t=${ac_cv_sizeof_dev_t}
		export ac_cv_sizeof_wchar=${ac_cv_sizeof_wchar_t}

		export ac_cv_type_prototypes="yes"
		export ac_cv_func_mlock{,all}="yes"
		export ac_cv_func_{e,f,g}cvt=$(usex elibc_glibc)
		export ac_cv_func_dtoa_r="no"
		export ac_cv_func_sys_siglist{,_def}="no"
		export ac_cv_func_printf_{j,ll}="yes"
		export ac_cv_realloc_null="yes"
		export ac_cv_no_user_malloc="no"
		export ac_cv_var_timezone="yes"
		export ac_cv_var___progname{,_full}="yes"
		export ac_cv_fnmatch_igncase="yes"
		export ac_cv_file__dev_{fd_{0,1,2},null,std{err,in,out},tty,zero}="yes"
		export ac_cv_file__usr_src_linux_include="no"

		case $(cdrtools_os) in
		linux)
			export ac_cv_func_bsd_{g,s}etpgrp="no"
			export ac_cv_hard_symlinks="yes"
			export ac_cv_link_nofollow="yes"
			export ac_cv_access_e_ok="no"

			export ac_cv_dev_minor_noncontig="yes"
			case ${ac_cv_sizeof_long_int} in
			4) export ac_cv_dev_minor_bits="32";;
			8) export ac_cv_dev_minor_bits="44";;
			esac

			cat <<-EOF >"${T}"/test.c
			struct {
				char start[6];
				unsigned char x1:4;
				unsigned char x2:4;
				char end[5];
			} a = {
				.start = {'S', 't', 'A', 'r', 'T', '_'},
				.x1 = 5,
				.x2 = 4,
				.end = {'_', 'e', 'N', 'd', 'X'},
			};
			EOF
			${CC} ${CPPFLAGS} ${CFLAGS} -c "${T}"/test.c -o "${T}"/test.o
			if grep -q 'StArT_E_eNdX' "${T}"/test.o ; then
				export ac_cv_c_bitfields_htol="no"
			elif grep -q 'StArT_T_eNdX' "${T}"/test.o ; then
				export ac_cv_c_bitfields_htol="yes"
			fi
			;;
		esac
	fi
}

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

	# If not built with -j1, "sometimes" cdda2wav will not be built.
	emake -j1 CPPOPTX="${CPPFLAGS}" COPTX="${CFLAGS}" C++OPTX="${CXXFLAGS}" \
		LDOPTX="${LDFLAGS}" GMAKE_NOWARN="true"
}

src_install() {
	# If not built with -j1, "sometimes" manpages are not installed.
	emake -j1 CPPOPTX="${CPPFLAGS}" COPTX="${CFLAGS}" C++OPTX="${CXXFLAGS}" \
		LDOPTX="${LDFLAGS}" GMAKE_NOWARN="true" install

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
