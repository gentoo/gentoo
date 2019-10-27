# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop virtualx

DESCRIPTION="Java application for Mind Mapping, Knowledge and Project Management"
HOMEPAGE="https://www.freeplane.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}%20stable/${PN}_src-${PV}.tar.gz
	https://github.com/rtgiskard/pkgs/raw/master/gentoo/distfiles/${PF}-gradle-cache.tar.xz"

## manually build freeplane with network, then pack cache for offline build:
# tar --xz -cf "${WORKDIR}/${PF}-gradle-cache.tar.xz" -C "${WORKDIR}" \
#	.gradle/caches/modules-2 || die

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

JAVA_PKG_IUSE="doc"
VIRTUALX_REQUIRED="test"

BDEPEND="dev-java/gradle-bin"
DEPEND=">=virtual/jre-1.8"

src_compile() {
	GRADLE="gradle --gradle-user-home ${WORKDIR}/.gradle --console rich --no-daemon"
	GRADLE="${GRADLE} --offline"

	${GRADLE} build -x check -x test || die
}

src_test() {
	virtx ${GRADLE} check test
}

src_install() {
	cd BIN || die
	sed -e "/freepath=/s:=.*:=${EROOT}/usr/share/${PN}:" \
		-i freeplane.sh || die
	newbin freeplane.sh freeplane

	insinto /usr/share/${PN}
	doins framework.jar freeplanelauncher.jar \
		freeplane.policy props.xargs init.xargs *.l4j.ini
	doins -r core doc fwdir plugins resources scripts

	doicon freeplane.svg
	make_desktop_entry freeplane
}
