# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature

DESCRIPTION="Small tools to aid with Gentoo development, primarily intended for QA"
HOMEPAGE="https://github.com/ionenwks/iwdevtools"
SRC_URI="https://github.com/ionenwks/iwdevtools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/pax-utils
	app-portage/portage-utils
	sys-apps/diffutils
	sys-apps/file
	sys-apps/portage
	sys-apps/util-linux"
BDEPEND="
	sys-apps/help2man
	test? ( ${RDEPEND} )"

src_configure() {
	local emesonargs=(
		-Ddocdir=${PF}
		-Deprefix="${EPREFIX}"
		-Dshellcheck=false
		$(meson_use test)
	)

	meson_src_configure
}

pkg_postinst() {
	optfeature "detecting potential ABI issues using abidiff" dev-util/libabigail

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Optional portage integration relies on using /etc/portage/bashrc."
		elog "The example bashrc can be used as-is if not already using one:"
		elog
		elog "    ln -s ../../usr/share/${PN}/bashrc ${EROOT}/etc/portage/bashrc"
		elog
		elog "Otherwise, inspect the tools' --help output and the example to integrate"
		elog "(if not defining the same phase functions, the example can be sourced)."
		elog
		elog "Note that \`eqawarn\` is used for portage output by default. QA messages"
		elog "aren't logged / shown post-emerge unless e.g. in /etc/portage/make.conf:"
		elog
		elog '    PORTAGE_ELOG_CLASSES="${PORTAGE_ELOG_CLASSES} qa"'
		elog
		elog "See ${EROOT}/usr/share/doc/${PF}/README.rst* for information on tools."
	fi

	if ver_test ${REPLACING_VERSIONS} -le 0.7.0; then
		elog "qa-* bashrcs now use \`eqawarn\` for portage output. If no longer"
		elog "seeing messages post-emerge, ensure 'qa' is in PORTAGE_ELOG_CLASSES."
	fi
}
