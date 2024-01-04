# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANT_TASK_JDKVER=1.8
ANT_TASK_JREVER=1.8
ANT_TASK_DEPNAME="bsf-2.3"

inherit ant-tasks

KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="python javascript tcl"

DEPEND=">=dev-java/bsf-2.4.0-r1:2.3[javascript?,tcl?]"
RDEPEND="${DEPEND}"

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Also, >=dev-java/bsf-2.4.0-r1 adds optional support for groovy,"
		elog "ruby and beanshell. See its postinst elog messages for instructions."
	fi
}
