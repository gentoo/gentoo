# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature

DESCRIPTION="Small tools to aid with Gentoo development, primarily intended for QA"
HOMEPAGE="https://github.com/ionenwks/iwdevtools"
SRC_URI="https://github.com/ionenwks/iwdevtools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/pax-utils
	app-portage/portage-utils
	>=app-shells/bash-5.1:0[readline]
	dev-libs/libxml2:2
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/file
	sys-apps/portage
	|| ( sys-apps/util-linux app-misc/getopt )"
BDEPEND="
	sys-apps/help2man
	|| ( sys-apps/util-linux app-misc/getopt )
	test? ( ${RDEPEND} )"

src_configure() {
	local emesonargs=(
		-Ddocdir=${PF}
		-Deprefix="${EPREFIX}"
		-Dshellcheck=false
		$(meson_use test)
	)

	has_version sys-apps/util-linux || emesonargs+=( -Dgetopt=getopt-long )

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
}
