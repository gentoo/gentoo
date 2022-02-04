# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Lightning-fast unified analytics engine"
HOMEPAGE="https://spark.apache.org"
SRC_URI="mirror://apache/spark/spark-${PV}/spark-${PV}-bin-hadoop3.2.tgz -> ${P}-hadoop.tgz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8"

S="${WORKDIR}/spark-${PV}-bin-hadoop3.2"

DOCS=( LICENSE NOTICE README.md RELEASE )

# Nothing to compile here.
src_compile() { :; }

src_install() {
	dodir usr/lib/spark-${SLOT}
	into usr/lib/spark-${SLOT}

	local spark_scripts=(
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
	for s in "${spark_scripts[@]}"; do
		dobin "${s}"
	done

	insinto usr/lib/spark-${SLOT}

	local spark_dirs=( conf jars python sbin yarn )

	local d
	for d in "${spark_dirs[@]}"; do
		doins -r "${d}"
	done

	newenvd - "50${PN}${SLOT}" <<-_EOF_
		PATH="/usr/lib/spark-${SLOT}/bin:/usr/lib/spark-${SLOT}/sbin"
		SPARK_HOME="/usr/lib/spark-${SLOT}"
	_EOF_

	einstalldocs
}

pkg_postinst() {
	einfo
	einfo "Spark is now slotted. You have installed Spark ${SLOT}."
	einfo
}
