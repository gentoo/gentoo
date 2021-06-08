# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Using a binary ebuild until a source ebuild is doable.
# This was previously blocked by two major bugs upstream:
# A lack of documented build instructions - https://www.jfrog.com/jira/browse/RTFACT-8960
# A lack of source releases - https://www.jfrog.com/jira/browse/RTFACT-8961
# Upstream now releases source and instructions (yay!), but most of artifactory's
# dependencies are not in portage yet.

EAPI=7

inherit java-pkg-2 systemd

MY_P="${P/-bin}"
MY_PN="${PN/-bin}"
MY_PV="${PV/-bin}"

DESCRIPTION="The world's most advanced repository manager for maven"
HOMEPAGE="http://www.jfrog.org/products.php"
SRC_URI="https://bintray.com/artifact/download/jfrog/artifactory/jfrog-artifactory-oss-${MY_PV}.zip -> ${MY_P}.zip"
S="${WORKDIR}/${MY_PN}-oss-${MY_PV}"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="
	acct-group/artifactory
	acct-user/artifactory
"
RDEPEND="
	${DEPEND}
	>=virtual/jre-1.8
"
BDEPEND="app-arch/unzip"

limitsdfile=40-${MY_PN}.conf

print_limitsdfile() {
	printf "# Start of ${limitsdfile} from ${P}\n\n"
	printf "@${MY_PN}\t-\tnofile\t32000\n"
	printf "\n# End of ${limitsdfile} from ${P}\n"
}

src_prepare() {
	default

	if use ssl ; then
		cp "${FILESDIR}/artifactory.xml" tomcat/conf/Catalina/localhost/artifactory.xml || die
		cp "${FILESDIR}/server.xml" tomcat/conf/server.xml || die
	fi

	# Reverse https://www.jfrog.com/jira/browse/RTFACT-7123
	sed -i -e "s%artifactory.repo.global.disabled=true%artifactory.repo.global.disabled=false%g;" \
		etc/artifactory.system.properties || die

	# See FIXME in src_install(), this can probably go away,
	# but catalina.sh may need to be fixed for that:
	sed -i -e "s%/etc/opt/jfrog/artifactory/default%/etc/conf.d/${MY_PN}%g;" \
		misc/service/setenv.sh || die

	einfo "Generating ${limitsdfile}"
	print_limitsdfile > "${S}/${limitsdfile}"
}

src_install() {
	local ARTIFACTORY_HOME="/opt/artifactory"
	local TOMCAT_HOME="${ARTIFACTORY_HOME}/tomcat"

	insinto ${ARTIFACTORY_HOME}
	doins -r etc misc tomcat webapps

	dodir /etc/opt/jfrog
	dosym ${ARTIFACTORY_HOME}/etc /etc/opt/jfrog/artifactory

	exeinto ${ARTIFACTORY_HOME}/bin
	doexe bin/*

	# FIXME: this is called by catalina.sh (it echoes the variables before starting
	# artifactory, as well as makes sure log dir, etc. exists). Those directories
	# could probably be moved to the ebuild and the script removed from catalina.sh
	# without consequence (and quieter starts). Would need to check if CATALINA_*
	# variables are actually used anywhere (from reading code don't appear to be
	# actually needed)
	exeinto ${TOMCAT_HOME}/bin
	doexe misc/service/setenv.sh
	doexe tomcat/bin/*

	keepdir ${ARTIFACTORY_HOME}/backup
	keepdir ${ARTIFACTORY_HOME}/data
	keepdir ${ARTIFACTORY_HOME}/run
	keepdir ${ARTIFACTORY_HOME}/work
	keepdir ${TOMCAT_HOME}/logs/catalina
	keepdir ${TOMCAT_HOME}/temp
	keepdir ${TOMCAT_HOME}/work
	keepdir /var/opt/jfrog/artifactory/run

	newconfd "${FILESDIR}/confd" ${MY_PN}
	newinitd "${FILESDIR}/initd-r3" ${MY_PN}

	systemd_dounit misc/service/artifactory.service

	fowners -R artifactory:artifactory ${ARTIFACTORY_HOME}
	fperms -R u+w ${TOMCAT_HOME}/work

	insinto /etc/security/limits.d
	doins "${S}/${limitsdfile}"
}
