# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="https://www.antlr3.org/"
# Reuse tarball for DOCS
SRC_URI="https://github.com/${PN}/${PN}3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3.5"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

CP_DEPEND="
	~dev-java/antlr-runtime-${PV}:${SLOT}
	~dev-java/antlr-tool-${PV}:${SLOT}
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${PN}3-${PV}"

DOCS=( contributors.txt README.txt )

src_compile() {
	:
}

src_install() {
	java-pkg_regjar "$(java-pkg_getjar "antlr-runtime-${SLOT}" antlr-runtime.jar)"
	java-pkg_regjar "$(java-pkg_getjar "antlr-tool-${SLOT}" antlr-tool.jar)"

	java-pkg_dolauncher "${PN}${SLOT}" --main org.antlr.Tool
	einstalldocs # https://bugs.gentoo.org/789582
}

pkg_postinst() {
	# If upgrading from a version of this slot that installs JARs,
	# display a message about submodule split
	local changed_ver="3.5.2-r2"
	local should_show_msg
	for replaced_ver in ${REPLACING_VERSIONS}; do
		if ver_test "${replaced_ver}" -lt "${changed_ver}"; then
			should_show_msg=1
			break
		fi
	done
	[[ "${should_show_msg}" ]] || return
	elog "Since version ${changed_ver}, ${PN}-${SLOT} no longer installs JARs."
	elog "Please find the JARs from files installed by submodule packages"
	elog "antlr-runtime-${SLOT} and antlr-tool-${SLOT}."
}
