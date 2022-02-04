# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Pseudo incremental backup with different exclude lists using hardlinks and rsync"
HOMEPAGE="https://www.nico.schottelius.org/software/ccollect/"
SRC_URI="https://www.nico.schottelius.org/software/${PN}/download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~sparc x86"
IUSE="doc examples"

DEPEND="
	doc? (
		>=app-text/asciidoc-8.1.0
		app-text/docbook-xsl-stylesheets
		app-text/docbook-xml-dtd:4.2
		dev-libs/libxslt
	)"
RDEPEND="net-misc/rsync"

# tests need ssh-access
RESTRICT="test"

src_compile() {
	use doc && emake XSL=/usr/share/sgml/docbook/xsl-stylesheets/html/docbook.xsl documentation
}

src_install() {
	dobin ccollect.sh
	dosym ccollect.sh /usr/bin/ccollect

	local i
	for i in add_source analyse_logs archive_config check_config \
	delete_source list_intervals logwrapper stats; do
		newbin tools/ccollect_${i}.sh ccollect_${i}
	done

	insinto /usr/share/${PN}/tools
	doins tools/config-pre* tools/{gnu-du-backup-size-compare,report_success}.sh

	pushd doc/changes >/dev/null || die
		for i in * ; do
			newdoc ${i} NEWS-${i}
		done
	popd >/dev/null || die

	if use doc; then
		doman doc/man/*.1

		find doc/ \( -iname '*.1' -o -iname '*.text' \) -delete || die
		HTML_DOCS=( doc/{*.htm{,l},man} )
	fi
	einstalldocs

	if use examples ; then
		docinto examples
		dodoc -r conf/.
	fi
}

pkg_postinst() {
	ewarn "If you're upgrading from 0.6.x or less, you'll have to"
	ewarn "upgrade your existing configuration as follows:"
	ewarn "1. Make the scripts in ${EROOT%/}/usr/share/ccollect/scripts executable"
	ewarn "2. Run all config-pre-\$VER-to-\$VER.sh in ${EROOT%/}/usr/share/ccollect/scripts"
	ewarn "   ascending order, where \$VER is greater or equal than the version"
	ewarn "   you upgraded from."
	ewarn "Example:"
	ewarn "  You upgraded from 0.5, thus you have to run:"
	ewarn "  ${EROOT%/}/usr/share/ccollect/tools/config-pre-0.6-to-0.6.sh"
	ewarn "  ${EROOT%/}/usr/share/ccollect/tools/config-pre-0.7-to-0.7.sh"

	elog "Please note that many tools are now installed directly to ${EROOT%/}/usr/bin"
	elog "as recommended by upstream."
}
