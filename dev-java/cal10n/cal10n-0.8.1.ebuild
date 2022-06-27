# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="ch.qos.cal10n:cal10n-api:0.8.1"
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="java library for writing localized messages using resource bundle"
HOMEPAGE="http://cal10n.qos.ch/"
SRC_URI="https://github.com/qos-ch/cal10n/archive/v_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/cal10n-v_${PV}/${PN}-api"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

# There are compilation errors in test phase:
# warning: Supported source version 'RELEASE_5' from annotation processor 'ch.qos.cal10n.verifier.processor.CAL10NAnnotationProcessor' less than -source '8'
# src/test/java/ch/qos/cal10n/util/Fruit.java:30: error: Failed to locate resource bundle [fruits] for locale [fr] for enum type [ch.qos.cal10n.util.Fruit]
# public enum Fruit {
#        ^
# src/test/java/ch/qos/cal10n/util/Fruit.java:30: error: Failed to locate resource bundle [fruits] for locale [en] for enum type [ch.qos.cal10n.util.Fruit]
# public enum Fruit {
#        ^
# src/test/java/ch/qos/cal10n/sample/Minimal.java:34: error: Missing or empty @LocaleData annotation in enum type [ch.qos.cal10n.sample.Minimal]. See http://cal10n.qos.ch/codes.html#missingLDAnnotation
# public enum Minimal {
#        ^
# src/test/java/ch/qos/cal10n/sample/Labels.java:9: error: Missing or empty @LocaleData annotation in enum type [ch.qos.cal10n.sample.Labels]. See http://cal10n.qos.ch/codes.html#missingLDAnnotation
# public enum Labels {
#        ^
# src/test/java/ch/qos/cal10n/sample/Host.java:8: error: Missing or empty @LocaleData annotation in enum type [ch.qos.cal10n.sample.Host.OtherColors]. See http://cal10n.qos.ch/codes.html#missingLDAnnotation
#   public enum OtherColors {
#          ^
# src/test/java/ch/qos/cal10n/sample/Furnitures.java:33: error: Failed to locate resource bundle [furnitures] for locale [en_UK] for enum type [ch.qos.cal10n.sample.Furnitures]
# public enum Furnitures {
#        ^
# src/test/java/ch/qos/cal10n/sample/Countries.java:33: error: Key [CH] present in enum type [ch.qos.cal10n.sample.Countries] but absent in resource bundle named [countries] for locale [en]
# public enum Countries {
#        ^
# src/test/java/ch/qos/cal10n/sample/Countries.java:33: error: Key [BR] present in resource bundle named [countries] for locale [en] but absent in enum type [ch.qos.cal10n.sample.Countries]
# public enum Countries {
#        ^
# src/test/java/ch/qos/cal10n/sample/Countries.java:33: error: Key [CH] present in enum type [ch.qos.cal10n.sample.Countries] but absent in resource bundle named [countries] for locale [fr]
# public enum Countries {
#        ^
# src/test/java/ch/qos/cal10n/sample/Countries.java:33: error: Key [CN] present in enum type [ch.qos.cal10n.sample.Countries] but absent in resource bundle named [countries] for locale [fr]
# public enum Countries {
#        ^
# src/test/java/ch/qos/cal10n/sample/Countries.java:33: error: Key [BR] present in resource bundle named [countries] for locale [fr] but absent in enum type [ch.qos.cal10n.sample.Countries]
# public enum Countries {
#        ^
# 11 errors

# JAVA_TEST_GENTOO_CLASSPATH="junit-4"
# JAVA_TEST_SRC_DIR="src/test/java"
# JAVA_TEST_RESOURCE_DIRS="src/test/resources"
