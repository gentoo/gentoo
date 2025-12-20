# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver java-pkg-2

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="https://www.antlr3.org/"
# Reuse tarball for DOCS
SRC_URI="https://github.com/${PN}/${PN}3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3.5"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

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
	ver_replacing -lt "${changed_ver}" || return
	elog "Since version ${changed_ver}, ${PN}-${SLOT} no longer installs JARs."
	elog "Please find the JARs from files installed by submodule packages"
	elog "antlr-runtime-${SLOT} and antlr-tool-${SLOT}."
}
