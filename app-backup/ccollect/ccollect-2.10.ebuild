# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="Pseudo incremental backup with different exclude lists using hardlinks and rsync"
HOMEPAGE="https://www.nico.schottelius.org/software/ccollect/"
SRC_URI="https://www.nico.schottelius.org/software/${PN}/download/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="doc examples"
# tests need ssh-access
RESTRICT="test"

RDEPEND="net-misc/rsync"
BDEPEND="
	doc? (
		>=app-text/asciidoc-8.1.0
		app-text/docbook-xsl-stylesheets
		app-text/docbook-xml-dtd:4.2
		dev-libs/libxslt
	)
"

src_compile() {
	use doc && emake XSL="${BROOT}"/usr/share/sgml/docbook/xsl-stylesheets/html/docbook.xsl documentation
}

src_install() {
	dodir /usr/bin

	# Makefile tries to install things to a /usr/local prefix and then
	# symlink some parts in /usr to it. Divert that to a trash directory.
	mkdir "${T}"/trash || die

	emake -j1 \
		prefix="${ED}" \
		path_dir="${T}"/trash \
		mandest="${ED}"/usr/share/man/man1 \
		manlink="${T}"/trash \
		install

	hprefixify "${ED}"/bin/ccollect

	# These aren't installed by the Makefile, unfortunately.
	local i
	for i in add_source analyse_logs archive_config check_config \
	delete_source list_intervals logwrapper stats; do
		hprefixify tools/ccollect_${i}
		dobin tools/ccollect_${i}
	done

	insinto /usr/share/${PN}/tools
	hprefixify tools/config-pre* tools/{old/gnu-du-backup-size-compare,report_success}
	doins tools/config-pre* tools/{old/gnu-du-backup-size-compare,report_success}

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
	ewarn "1. Make the scripts in ${EROOT}/usr/share/ccollect/scripts executable"
	ewarn "2. Run all config-pre-\$VER-to-\$VER.sh in ${EROOT}/usr/share/ccollect/scripts"
	ewarn "   ascending order, where \$VER is greater or equal than the version"
	ewarn "   you upgraded from."
	ewarn "Example:"
	ewarn "  You upgraded from 0.5, thus you have to run:"
	ewarn "  ${EROOT}/usr/share/ccollect/tools/config-pre-0.6-to-0.6.sh"
	ewarn "  ${EROOT}/usr/share/ccollect/tools/config-pre-0.7-to-0.7.sh"

	elog "Please note that many tools are now installed directly to ${EROOT}/usr/bin"
	elog "as recommended by upstream."
}
