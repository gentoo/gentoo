# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Lightning-fast unified analytics engine"
HOMEPAGE="https://spark.apache.org"
SRC_URI="mirror://apache/spark/spark-${PV}/spark-${PV}-bin-hadoop2.7.tgz -> ${P}.tgz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8"

S="${WORKDIR}/spark-${PV}-bin-hadoop2.7"

DOCS=( LICENSE NOTICE README.md RELEASE )

# Nothing to compile here.
src_compile() { :; }

src_install() {
	dodir usr/lib/spark-${SLOT}
	into usr/lib/spark-${SLOT}

	dobin bin/beeline \
		bin/find-spark-home \
		bin/pyspark \
		bin/spark-class \
		bin/spark-shell \
		bin/spark-sql \
		bin/spark-submit

	insinto usr/lib/spark-${SLOT}/bin
	doins bin/load-spark-env.sh

	insinto usr/lib/spark-${SLOT}
	doins -r conf
	doins -r jars
	doins -r python
	doins -r sbin
	doins -r yarn

	einstalldocs
}

pkg_postinst() {
	einfo
	einfo "Spark is now slotted. You have installed Spark ${SLOT}."
	einfo
	einfo "Make sure to add /usr/lib/spark-${SLOT}/{bin,sbin} directories"
	einfo "to your PATH in order to run Spark shell scripts:"
	einfo
	einfo "$ export PATH=\$PATH:/usr/lib/spark-${SLOT}/bin"
	einfo "$ export PATH=\$PATH:/usr/lib/spark-${SLOT}/sbin"
	einfo
}
