package org.xtext.builddsl.scoping

import com.google.common.collect.Maps
import com.google.common.collect.Sets
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.scoping.featurecalls.StaticImplicitMethodsFeatureForTypeProvider
import org.xtext.builddsl.build.BuildFile

/**
 * @author Sebastian Zarnekow - Initial contribution and API
 */
class AllImportsAreStaticFeatureProvider extends StaticImplicitMethodsFeatureForTypeProvider {

	override getVisibleTypesContainingStaticMethods(Iterable<JvmTypeReference> hierarchy) {
		val buildFile = getContext.getContents.get(0) as BuildFile
		val importedTypes = <String>newArrayList
		for (importDeclaration : buildFile.imports) {
			val importedTypeOrPackage = importDeclaration.importedNamespace
			if (!importedTypeOrPackage.endsWith(".*")) {
				importedTypes += importedTypeOrPackage
			}
		}
		val result = Maps::newLinkedHashMap(super.getVisibleTypesContainingStaticMethods(hierarchy))
		for (entry : result.entrySet) {
			val copy = Sets::newLinkedHashSet(entry.getValue)
			copy += importedTypes
			entry.value = copy
		}
		result
	}
	
}