# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit prefix

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="http://bash-completion.alioth.debian.org/"
SRC_URI="http://bash-completion.alioth.debian.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"
IUSE=""

DEPEND=""
RDEPEND="|| ( app-eselect/eselect-bashcomp <app-admin/eselect-1.3.7 )
	|| ( >=app-shells/bash-3.2 app-shells/zsh )
	sys-apps/miscfiles"
PDEPEND="app-shells/gentoo-bashcomp"

src_prepare() {
	cp "${FILESDIR}"/bash-completion.sh-gentoo-1.2 "${T}"/bash-completion.sh || die
	eprefixify "${T}"/bash-completion.sh

	find completions -name 'Makefile*' -exec rm -f {} +

	# Part of >=sys-apps/util-linux-2.23 wrt #468544
	rm -f completions/rtcwake
}

src_configure() { :; } # no-op
src_compile() { :; } # no-op

src_install() {
	# Gentoo specific bash-completion.sh file.
	insinto /etc/profile.d
	doins "${T}"/bash-completion.sh || die

	# All files from contrib/ in source package get installed
	insinto /usr/share/bash-completion
	doins -r "${S}"/completions/* || die

	awk -v D="$ED" '
	BEGIN { out=".pre" }
	/^# A lot of the following one-liners/ { out="base" }
	/^# start of section containing completion functions called by other functions/ { out=".pre" }
	/^# start of section containing completion functions for external programs/ { out="base" }
	/^# source completion directory/ { out="" }
	/^unset -f have/ { out=".post" }
	out != "" { print > D"/usr/share/bash-completion/"out }' \
	bash_completion || die "failed to split bash_completion"

	dodoc AUTHORS CHANGES README TODO || die "dodocs failes"

	# This is backported from upstream 2.0 release. You can stop installing
	# this file after 2.0 is in Portage and use the one from the tarball
	# instead.
	# Installed to datadir instead of libdir because bash-completion(s)
	# are not ELF files.
	insinto /usr/share/pkgconfig
	doins "${FILESDIR}"/bash-completion.pc || die
}

pkg_postinst() {
	elog "Any user can enable the module completions without editing their"
	elog ".bashrc by running:"
	elog
	elog "    eselect bashcomp enable <module>"
	elog
	elog "The system administrator can also be enable this globally with"
	elog
	elog "    eselect bashcomp enable --global <module>"
	elog
	elog "Make sure you at least enable the base module! Additional completion"
	elog "modules can be found by running"
	elog
	elog "    eselect bashcomp list"
	elog
	elog "If you use non-login shells you still need to source"
	elog "/etc/profile.d/bash-completion.sh in your ~/.bashrc."

	if has_version 'app-shells/zsh' ; then
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog
	fi
}
