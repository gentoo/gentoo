# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Lightning-fast unified analytics engine"
HOMEPAGE="https://spark.apache.org"
SRC_URI="mirror://apache/spark/spark-${PV}/spark-${PV}-bin-hadoop2.7.tgz -> ${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
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
	dodir usr/lib/spark
	into usr/lib/spark

	dobin bin/beeline \
		bin/find-spark-home \
		bin/pyspark \
		bin/spark-class \
		bin/spark-shell \
		bin/spark-sql \
		bin/spark-submit

	insinto usr/lib/spark/bin
	doins bin/load-spark-env.sh

	insinto usr/lib/spark
	doins -r conf
	doins -r jars
	doins -r python
	doins -r sbin
	doins -r yarn

	dosym ../lib/spark/bin/beeline /usr/bin/beeline
	dosym ../lib/spark/bin/find-spark-home /usr/bin/find-spark-home
	dosym ../lib/spark/bin/pyspark /usr/bin/pyspark
	dosym ../lib/spark/bin/spark-class /usr/bin/spark-class
	dosym ../lib/spark/bin/spark-shell /usr/bin/spark-shell
	dosym ../lib/spark/bin/spark-sql /usr/bin/spark-sql
	dosym ../lib/spark/bin/spark-submit /usr/bin/spark-submit

	doenvd "${FILESDIR}"/99spark
	einstalldocs
}
