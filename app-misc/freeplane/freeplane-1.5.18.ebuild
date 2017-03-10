# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc"

VIRTUALX_REQUIRED="test"

inherit java-utils-2 virtualx

DESCRIPTION="Java application for Mind Mapping, Knowledge and Project Management"
HOMEPAGE="https://www.freeplane.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}%20stable/${PN}_src-${PV}.tar.gz
	http://dev.gentoo.org/~xmw/distfiles/freeplane-1.5.18-gradle-cache.tar.xz"
#generate cache file by disabling --offline, ebuild clean test and
#tar cvJf /var/cache/distfiles/freeplane-1.5.18-gradle-cache.tar.xz -C /var/tmp/portage/app-misc/freeplane-1.5.18/work .gradle/caches/modules-2

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.8"
DEPEND="${DEPEND}
	>=virtual/jdk-1.8
	dev-java/gradle-bin"

src_compile() {
	GRADLE="gradle --gradle-user-home ${WORKDIR}/.gradle --console rich --no-daemon"
	GRADLE="${GRADLE} --offline"
	${GRADLE} build -x check -x test || die
}

src_test() {
	virtx ${GRADLE} check test || die
}

src_install() {
	cd BUILD || die
	sed -e "/freepath=/s:=.*:=${EROOT}usr/share/${PN}:" \
		-i freeplane.sh
	newbin freeplane.sh freeplane

	insinto /usr/share/${PN}
	doins framework.jar freeplanelauncher.jar \
		freeplane.policy props.xargs init.xargs *.l4j.ini
	doins -r core doc fwdir plugins resources
}
