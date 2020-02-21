# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

MY_P="${P/_/-}"
DESCRIPTION="Small and simple weblog engine written in Bash for the command-line"
HOMEPAGE="http://nanoblogger.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ia64 ~mips ppc x86"

RDEPEND="app-shells/bash"

S="${WORKDIR}/${MY_P}"

HTML_DOCS=( docs/nanoblogger.html )

src_prepare() {
	default
	sed -i \
		-e 's|^\(NB_BASE_DIR=\).*$|\1"/usr/share/nanoblogger"|' \
		-e 's|^\(NB_CFG_DIR=\).*$|\1"/etc"|' \
		-e "s|\$NB_BASE_DIR.*\(nano.*html\)|/usr/share/doc/${PF}/html/\1|" \
			nb || die "sed nb failed"
}

src_install() {
	dobin nb
	insinto /usr/share/nanoblogger
	doins -r default moods plugins lib lang docs welcome-to-nb.txt
	insinto /etc
	doins nb.conf
	einstalldocs
	dobashcomp "${FILESDIR}"/nb.bashcomp
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
	elog "You also should remove your [newblog_dir]/data/cat_1.db and run:"
	elog "		nb -u all"
	elog "after copying your old entries from [oldblog_dir]/data to"
	elog "[newblog_dir]/data."
	elog
}
