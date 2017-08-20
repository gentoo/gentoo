# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="vala"

inherit gnome.org

DESCRIPTION="Build infrastructure for packages that use Vala"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE=""

# Previously ${PN} was part of dev-lang/vala
RDEPEND="
	!<dev-lang/vala-0.10.4-r2
	!<dev-lang/vala-0.12.1-r1:0.12
	!<dev-lang/vala-0.14.2-r2:0.14
	!<dev-lang/vala-0.16.1-r2:0.16
	!<dev-lang/vala-0.17.5:0.18
"
DEPEND=""

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/aclocal
	doins vala.m4 vapigen/vapigen.m4
	insinto /usr/share/vala
	doins vapigen/Makefile.vapigen
}

pkg_postinst() {
	# Hack to prevent alternatives_auto_makesym in previously installed
	# dev-lang/vala's pkg_postrm from overwriting vala-common's files
	if has_version '<dev-lang/vala-0.10.4-r2:0.10' && [[ -f "${EROOT}usr/share/aclocal/vala-0-10.m4" ]]; then
		ebegin "Removing old vala-0.10 macros"
		rm "${EROOT}usr/share/aclocal/vala-0-10.m4" &> /dev/null
		eend $?
	fi
	if has_version '<dev-lang/vala-0.12.1-r1:0.12' && [[ -f "${EROOT}usr/share/aclocal/vala-0-12.m4" ]]; then
		ebegin "Removing old vala-0.12 macros"
		rm "${EROOT}usr/share/aclocal/vala-0-12.m4" &> /dev/null
		eend $?
	fi
	if has_version '<dev-lang/vala-0.14.2-r2:0.14' && [[ -f "${EROOT}usr/share/aclocal/vala-0-14.m4" ]]; then
		ebegin "Removing old vala-0.14 macros"
		rm "${EROOT}usr/share/aclocal/vala-0-14.m4" &> /dev/null
		eend $?
	fi
	if has_version '<dev-lang/vala-0.16.1-r2:0.16' && [[ -f "${EROOT}usr/share/aclocal/vala-0-16.m4" ]]; then
		ebegin "Removing old vala-0.16 macros"
		rm "${EROOT}usr/share/aclocal/vala-0-14.m4" &> /dev/null
		eend $?
		if [[ -f "${EROOT}usr/share/vala-0.16/Makefile.vapigen" ]]; then
			ebegin "Removing old vala-0.16 makefile template"
			rm "${EROOT}usr/share/vala-0.16/Makefile.vapigen" &> /dev/null
			eend $?
		fi
	fi
	if has_version '<dev-lang/vala-0.17.5:0.18' && [[ -f "${EROOT}usr/share/aclocal/vala-0-18.m4" ]]; then
		ebegin "Removing old vala-0.18 macros"
		rm "${EROOT}usr/share/aclocal/vala-0-12.m4" &> /dev/null
		eend $?
		if [[ -f "${EROOT}usr/share/vala-0.18/Makefile.vapigen" ]]; then
			ebegin "Removing old vala-0.18 makefile template"
			rm "${EROOT}usr/share/vala-0.18/Makefile.vapigen" &> /dev/null
			eend $?
		fi
	fi
}
