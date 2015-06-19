# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/nanoblogger/nanoblogger-3.2.3.ebuild,v 1.12 2011/10/02 05:07:58 radhermit Exp $

inherit bash-completion-r1

DESCRIPTION="Small and simple weblog engine written in Bash for the command-line"
HOMEPAGE="http://nanoblogger.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc x86"
IUSE=""

RDEPEND="app-shells/bash"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's|^\(NB_BASE_DIR=\).*$|\1"/usr/share/nanoblogger"|' \
		-e 's|"$NB_BASE_DIR/\(nb\.conf\)"|"/etc/\1"|g' \
		-e "s|\$NB_BASE_DIR.*\(nano.*html\)|/usr/share/doc/${PF}/html/\1|" \
			nb || die "sed nb failed"
}

src_install() {
	dobin nb
	insinto /usr/share/nanoblogger
	doins -r default moods plugins
	insinto /etc
	doins nb.conf
	dodoc ChangeLog
	dohtml docs/nanoblogger.html
	dobashcomp "${FILESDIR}"/nb.bashcomp || die
}

pkg_postinst() {
	elog
	elog "Documentation for getting started with nanoblogger may be found at"
	elog "/usr/share/doc/${PF}/html/nanoblogger.html or by running 'nb --manual;."
	elog
	elog "To create and configure a new weblog, run the following as your user:"
	elog "   nb -b /some/dir -a"
	elog "where /some/dir is a directory that DOES NOT exist."
	elog
	elog "To prevent having to specify your blog directory every time you use"
	elog "nanoblogger (with the -b switch), you can set a default value in your"
	elog "~/.nb.conf.  For example:"
	elog '   BLOG_DIR="$HOME/public_html/blog"'
	elog
	elog "If you are upgrading nanoblogger from a previous version, follow"
	elog "these directions (as stated in the manual):"
	elog "    1. create a new weblog directory using nanoblogger (skip configuration):"
	elog "      nb [-b blog_dir] -a"
	elog "    2. copy old data directry to new weblog:"
	elog "      cp -r [old_blog_dir]/data [newblog_dir]"
	elog "    3. edit new blog.conf to your liking and rebuild weblog:"
	elog "      nb [-b blog_dir] --configure -u all"
	elog
}
