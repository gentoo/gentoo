# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Lightning-fast unified analytics engine"
HOMEPAGE="https://spark.apache.org"
SRC_URI="
	!scala212? ( scala211? ( mirror://apache/spark/spark-${PV}/spark-${PV}-bin-without-hadoop.tgz -> ${P}-nohadoop-scala211.tgz ) )
	!scala211? ( scala212? ( mirror://apache/spark/spark-${PV}/spark-${PV}-bin-without-hadoop-scala-2.12.tgz -> ${P}-nohadoop-scala212.tgz ) )
"

REQUIRED_USE="^^ ( scala211 scala212 )"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"

IUSE="scala211 scala212"

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8"

DOCS=( LICENSE NOTICE README.md RELEASE )

src_unpack() {
	unpack ${A}
	use scala211 && S="${WORKDIR}/spark-${PV}-bin-without-hadoop"
	use scala212 && S="${WORKDIR}/spark-${PV}-bin-without-hadoop-scala-2.12"
}

# Nothing to compile here.
src_compile() { :; }

src_install() {
	dodir usr/lib/spark-${SLOT}
	into usr/lib/spark-${SLOT}

	local SPARK_SCRIPTS=(
		bin/beeline
		bin/find-spark-home
		bin/load-spark-env.sh
		bin/pyspark
		bin/spark-class
		bin/spark-shell
		bin/spark-sql
		bin/spark-submit
	)

	local s
	for s in "${SPARK_SCRIPTS[@]}"; do
		dobin "${s}"
	done

	insinto usr/lib/spark-${SLOT}

	local SPARK_DIRS=( conf jars python sbin yarn )

	local d
	for d in "${SPARK_DIRS[@]}"; do
		doins -r "${d}"
	done

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
