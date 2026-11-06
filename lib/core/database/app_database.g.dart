// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalCategoriesTable extends LocalCategories
    with TableInfo<$LocalCategoriesTable, LocalCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slug, name, iconKey, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug};
  @override
  LocalCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCategory(
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LocalCategoriesTable createAlias(String alias) {
    return $LocalCategoriesTable(attachedDatabase, alias);
  }
}

class LocalCategory extends DataClass implements Insertable<LocalCategory> {
  final String slug;
  final String name;
  final String iconKey;
  final int sortOrder;
  const LocalCategory({
    required this.slug,
    required this.name,
    required this.iconKey,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    map['icon_key'] = Variable<String>(iconKey);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LocalCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LocalCategoriesCompanion(
      slug: Value(slug),
      name: Value(name),
      iconKey: Value(iconKey),
      sortOrder: Value(sortOrder),
    );
  }

  factory LocalCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCategory(
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'iconKey': serializer.toJson<String>(iconKey),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LocalCategory copyWith({
    String? slug,
    String? name,
    String? iconKey,
    int? sortOrder,
  }) => LocalCategory(
    slug: slug ?? this.slug,
    name: name ?? this.name,
    iconKey: iconKey ?? this.iconKey,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LocalCategory copyWithCompanion(LocalCategoriesCompanion data) {
    return LocalCategory(
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategory(')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slug, name, iconKey, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCategory &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.iconKey == this.iconKey &&
          other.sortOrder == this.sortOrder);
}

class LocalCategoriesCompanion extends UpdateCompanion<LocalCategory> {
  final Value<String> slug;
  final Value<String> name;
  final Value<String> iconKey;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LocalCategoriesCompanion({
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCategoriesCompanion.insert({
    required String slug,
    required String name,
    required String iconKey,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : slug = Value(slug),
       name = Value(name),
       iconKey = Value(iconKey),
       sortOrder = Value(sortOrder);
  static Insertable<LocalCategory> custom({
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? iconKey,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (iconKey != null) 'icon_key': iconKey,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCategoriesCompanion copyWith({
    Value<String>? slug,
    Value<String>? name,
    Value<String>? iconKey,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LocalCategoriesCompanion(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategoriesCompanion(')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> budget =
      GeneratedColumn<String>(
        'budget',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($ShoppingListsTable.$converterbudgetn);
  static const VerificationMeta _shoppingStateMeta = const VerificationMeta(
    'shoppingState',
  );
  @override
  late final GeneratedColumn<String> shoppingState = GeneratedColumn<String>(
    'shopping_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planning'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    updatedAt,
    budget,
    shoppingState,
    startedAt,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('shopping_state')) {
      context.handle(
        _shoppingStateMeta,
        shoppingState.isAcceptableOrUnknown(
          data['shopping_state']!,
          _shoppingStateMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      budget: $ShoppingListsTable.$converterbudgetn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}budget'],
        ),
      ),
      shoppingState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shopping_state'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $converterbudget =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterbudgetn =
      NullAwareTypeConverter.wrap($converterbudget);
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Orçamento da compra (null = não definido). Dinheiro em decimal exato.
  final Decimal? budget;

  /// 'planning' (montando a lista), 'shopping' (comprando) ou 'finished'.
  final String shoppingState;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  const ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.budget,
    required this.shoppingState,
    this.startedAt,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || budget != null) {
      map['budget'] = Variable<String>(
        $ShoppingListsTable.$converterbudgetn.toSql(budget),
      );
    }
    map['shopping_state'] = Variable<String>(shoppingState);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      budget: budget == null && nullToAbsent
          ? const Value.absent()
          : Value(budget),
      shoppingState: Value(shoppingState),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory ShoppingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      budget: serializer.fromJson<Decimal?>(json['budget']),
      shoppingState: serializer.fromJson<String>(json['shoppingState']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'budget': serializer.toJson<Decimal?>(budget),
      'shoppingState': serializer.toJson<String>(shoppingState),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<Decimal?> budget = const Value.absent(),
    String? shoppingState,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => ShoppingList(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    budget: budget.present ? budget.value : this.budget,
    shoppingState: shoppingState ?? this.shoppingState,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      budget: data.budget.present ? data.budget.value : this.budget,
      shoppingState: data.shoppingState.present
          ? data.shoppingState.value
          : this.shoppingState,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('budget: $budget, ')
          ..write('shoppingState: $shoppingState, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    updatedAt,
    budget,
    shoppingState,
    startedAt,
    finishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.budget == this.budget &&
          other.shoppingState == this.shoppingState &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<Decimal?> budget;
  final Value<String> shoppingState;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> rowid;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.budget = const Value.absent(),
    this.shoppingState = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.budget = const Value.absent(),
    this.shoppingState = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShoppingList> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? budget,
    Expression<String>? shoppingState,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (budget != null) 'budget': budget,
      if (shoppingState != null) 'shopping_state': shoppingState,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<Decimal?>? budget,
    Value<String>? shoppingState,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? rowid,
  }) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      budget: budget ?? this.budget,
      shoppingState: shoppingState ?? this.shoppingState,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (budget.present) {
      map['budget'] = Variable<String>(
        $ShoppingListsTable.$converterbudgetn.toSql(budget.value),
      );
    }
    if (shoppingState.present) {
      map['shopping_state'] = Variable<String>(shoppingState.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('budget: $budget, ')
          ..write('shoppingState: $shoppingState, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> quantity =
      GeneratedColumn<String>(
        'quantity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($ShoppingListItemsTable.$converterquantity);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categorySlugMeta = const VerificationMeta(
    'categorySlug',
  );
  @override
  late final GeneratedColumn<String> categorySlug = GeneratedColumn<String>(
    'category_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_categories (slug) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notFoundMeta = const VerificationMeta(
    'notFound',
  );
  @override
  late final GeneratedColumn<bool> notFound = GeneratedColumn<bool>(
    'not_found',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("not_found" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _substituteNameMeta = const VerificationMeta(
    'substituteName',
  );
  @override
  late final GeneratedColumn<String> substituteName = GeneratedColumn<String>(
    'substitute_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> foundPrice =
      GeneratedColumn<String>(
        'found_price',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($ShoppingListItemsTable.$converterfoundPricen);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> unitPrice =
      GeneratedColumn<String>(
        'unit_price',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($ShoppingListItemsTable.$converterunitPricen);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    name,
    quantity,
    unit,
    categorySlug,
    checked,
    position,
    notFound,
    substituteName,
    foundPrice,
    unitPrice,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category_slug')) {
      context.handle(
        _categorySlugMeta,
        categorySlug.isAcceptableOrUnknown(
          data['category_slug']!,
          _categorySlugMeta,
        ),
      );
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('not_found')) {
      context.handle(
        _notFoundMeta,
        notFound.isAcceptableOrUnknown(data['not_found']!, _notFoundMeta),
      );
    }
    if (data.containsKey('substitute_name')) {
      context.handle(
        _substituteNameMeta,
        substituteName.isAcceptableOrUnknown(
          data['substitute_name']!,
          _substituteNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: $ShoppingListItemsTable.$converterquantity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}quantity'],
        )!,
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      categorySlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_slug'],
      ),
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      notFound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}not_found'],
      )!,
      substituteName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}substitute_name'],
      ),
      foundPrice: $ShoppingListItemsTable.$converterfoundPricen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}found_price'],
        ),
      ),
      unitPrice: $ShoppingListItemsTable.$converterunitPricen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit_price'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $converterquantity =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterfoundPrice =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterfoundPricen =
      NullAwareTypeConverter.wrap($converterfoundPrice);
  static TypeConverter<Decimal, String> $converterunitPrice =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterunitPricen =
      NullAwareTypeConverter.wrap($converterunitPrice);
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final String id;
  final String listId;
  final String name;
  final Decimal quantity;
  final String unit;
  final String? categorySlug;

  /// Coletado = no carrinho. NÃO significa pago.
  final bool checked;
  final int position;

  /// "Não encontrei" no mercado (exclui o item do previsto).
  final bool notFound;

  /// Substituição explícita: nome do que foi levado no lugar.
  final String? substituteName;

  /// Preço encontrado no mercado (por unidade); separado do previsto.
  final Decimal? foundPrice;

  /// Preço pessoal do item; null = desconhecido (nunca zero como placeholder).
  final Decimal? unitPrice;
  final DateTime createdAt;
  const ShoppingListItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    required this.unit,
    this.categorySlug,
    required this.checked,
    required this.position,
    required this.notFound,
    this.substituteName,
    this.foundPrice,
    this.unitPrice,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_id'] = Variable<String>(listId);
    map['name'] = Variable<String>(name);
    {
      map['quantity'] = Variable<String>(
        $ShoppingListItemsTable.$converterquantity.toSql(quantity),
      );
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || categorySlug != null) {
      map['category_slug'] = Variable<String>(categorySlug);
    }
    map['checked'] = Variable<bool>(checked);
    map['position'] = Variable<int>(position);
    map['not_found'] = Variable<bool>(notFound);
    if (!nullToAbsent || substituteName != null) {
      map['substitute_name'] = Variable<String>(substituteName);
    }
    if (!nullToAbsent || foundPrice != null) {
      map['found_price'] = Variable<String>(
        $ShoppingListItemsTable.$converterfoundPricen.toSql(foundPrice),
      );
    }
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<String>(
        $ShoppingListItemsTable.$converterunitPricen.toSql(unitPrice),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      categorySlug: categorySlug == null && nullToAbsent
          ? const Value.absent()
          : Value(categorySlug),
      checked: Value(checked),
      position: Value(position),
      notFound: Value(notFound),
      substituteName: substituteName == null && nullToAbsent
          ? const Value.absent()
          : Value(substituteName),
      foundPrice: foundPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(foundPrice),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      createdAt: Value(createdAt),
    );
  }

  factory ShoppingListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<String>(json['id']),
      listId: serializer.fromJson<String>(json['listId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<Decimal>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      categorySlug: serializer.fromJson<String?>(json['categorySlug']),
      checked: serializer.fromJson<bool>(json['checked']),
      position: serializer.fromJson<int>(json['position']),
      notFound: serializer.fromJson<bool>(json['notFound']),
      substituteName: serializer.fromJson<String?>(json['substituteName']),
      foundPrice: serializer.fromJson<Decimal?>(json['foundPrice']),
      unitPrice: serializer.fromJson<Decimal?>(json['unitPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listId': serializer.toJson<String>(listId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<Decimal>(quantity),
      'unit': serializer.toJson<String>(unit),
      'categorySlug': serializer.toJson<String?>(categorySlug),
      'checked': serializer.toJson<bool>(checked),
      'position': serializer.toJson<int>(position),
      'notFound': serializer.toJson<bool>(notFound),
      'substituteName': serializer.toJson<String?>(substituteName),
      'foundPrice': serializer.toJson<Decimal?>(foundPrice),
      'unitPrice': serializer.toJson<Decimal?>(unitPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? listId,
    String? name,
    Decimal? quantity,
    String? unit,
    Value<String?> categorySlug = const Value.absent(),
    bool? checked,
    int? position,
    bool? notFound,
    Value<String?> substituteName = const Value.absent(),
    Value<Decimal?> foundPrice = const Value.absent(),
    Value<Decimal?> unitPrice = const Value.absent(),
    DateTime? createdAt,
  }) => ShoppingListItem(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    categorySlug: categorySlug.present ? categorySlug.value : this.categorySlug,
    checked: checked ?? this.checked,
    position: position ?? this.position,
    notFound: notFound ?? this.notFound,
    substituteName: substituteName.present
        ? substituteName.value
        : this.substituteName,
    foundPrice: foundPrice.present ? foundPrice.value : this.foundPrice,
    unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
    createdAt: createdAt ?? this.createdAt,
  );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      categorySlug: data.categorySlug.present
          ? data.categorySlug.value
          : this.categorySlug,
      checked: data.checked.present ? data.checked.value : this.checked,
      position: data.position.present ? data.position.value : this.position,
      notFound: data.notFound.present ? data.notFound.value : this.notFound,
      substituteName: data.substituteName.present
          ? data.substituteName.value
          : this.substituteName,
      foundPrice: data.foundPrice.present
          ? data.foundPrice.value
          : this.foundPrice,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('categorySlug: $categorySlug, ')
          ..write('checked: $checked, ')
          ..write('position: $position, ')
          ..write('notFound: $notFound, ')
          ..write('substituteName: $substituteName, ')
          ..write('foundPrice: $foundPrice, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    name,
    quantity,
    unit,
    categorySlug,
    checked,
    position,
    notFound,
    substituteName,
    foundPrice,
    unitPrice,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.categorySlug == this.categorySlug &&
          other.checked == this.checked &&
          other.position == this.position &&
          other.notFound == this.notFound &&
          other.substituteName == this.substituteName &&
          other.foundPrice == this.foundPrice &&
          other.unitPrice == this.unitPrice &&
          other.createdAt == this.createdAt);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<String> id;
  final Value<String> listId;
  final Value<String> name;
  final Value<Decimal> quantity;
  final Value<String> unit;
  final Value<String?> categorySlug;
  final Value<bool> checked;
  final Value<int> position;
  final Value<bool> notFound;
  final Value<String?> substituteName;
  final Value<Decimal?> foundPrice;
  final Value<Decimal?> unitPrice;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.categorySlug = const Value.absent(),
    this.checked = const Value.absent(),
    this.position = const Value.absent(),
    this.notFound = const Value.absent(),
    this.substituteName = const Value.absent(),
    this.foundPrice = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    required String id,
    required String listId,
    required String name,
    required Decimal quantity,
    required String unit,
    this.categorySlug = const Value.absent(),
    this.checked = const Value.absent(),
    required int position,
    this.notFound = const Value.absent(),
    this.substituteName = const Value.absent(),
    this.foundPrice = const Value.absent(),
    this.unitPrice = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listId = Value(listId),
       name = Value(name),
       quantity = Value(quantity),
       unit = Value(unit),
       position = Value(position),
       createdAt = Value(createdAt);
  static Insertable<ShoppingListItem> custom({
    Expression<String>? id,
    Expression<String>? listId,
    Expression<String>? name,
    Expression<String>? quantity,
    Expression<String>? unit,
    Expression<String>? categorySlug,
    Expression<bool>? checked,
    Expression<int>? position,
    Expression<bool>? notFound,
    Expression<String>? substituteName,
    Expression<String>? foundPrice,
    Expression<String>? unitPrice,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (categorySlug != null) 'category_slug': categorySlug,
      if (checked != null) 'checked': checked,
      if (position != null) 'position': position,
      if (notFound != null) 'not_found': notFound,
      if (substituteName != null) 'substitute_name': substituteName,
      if (foundPrice != null) 'found_price': foundPrice,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? listId,
    Value<String>? name,
    Value<Decimal>? quantity,
    Value<String>? unit,
    Value<String?>? categorySlug,
    Value<bool>? checked,
    Value<int>? position,
    Value<bool>? notFound,
    Value<String?>? substituteName,
    Value<Decimal?>? foundPrice,
    Value<Decimal?>? unitPrice,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      categorySlug: categorySlug ?? this.categorySlug,
      checked: checked ?? this.checked,
      position: position ?? this.position,
      notFound: notFound ?? this.notFound,
      substituteName: substituteName ?? this.substituteName,
      foundPrice: foundPrice ?? this.foundPrice,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(
        $ShoppingListItemsTable.$converterquantity.toSql(quantity.value),
      );
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (categorySlug.present) {
      map['category_slug'] = Variable<String>(categorySlug.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (notFound.present) {
      map['not_found'] = Variable<bool>(notFound.value);
    }
    if (substituteName.present) {
      map['substitute_name'] = Variable<String>(substituteName.value);
    }
    if (foundPrice.present) {
      map['found_price'] = Variable<String>(
        $ShoppingListItemsTable.$converterfoundPricen.toSql(foundPrice.value),
      );
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<String>(
        $ShoppingListItemsTable.$converterunitPricen.toSql(unitPrice.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('categorySlug: $categorySlug, ')
          ..write('checked: $checked, ')
          ..write('position: $position, ')
          ..write('notFound: $notFound, ')
          ..write('substituteName: $substituteName, ')
          ..write('foundPrice: $foundPrice, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceSnapshotsTable extends PriceSnapshots
    with TableInfo<$PriceSnapshotsTable, PriceSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_list_items (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> amount =
      GeneratedColumn<String>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($PriceSnapshotsTable.$converteramount);
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BRL'),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('predicted'),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    amount,
    currency,
    unit,
    kind,
    capturedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      amount: $PriceSnapshotsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amount'],
        )!,
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
    );
  }

  @override
  $PriceSnapshotsTable createAlias(String alias) {
    return $PriceSnapshotsTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $converteramount =
      const DecimalConverter();
}

class PriceSnapshot extends DataClass implements Insertable<PriceSnapshot> {
  final String id;
  final String itemId;
  final Decimal amount;
  final String currency;
  final String unit;

  /// 'predicted' (preço previsto da lista) ou 'found' (encontrado na compra).
  final String kind;
  final DateTime capturedAt;
  const PriceSnapshot({
    required this.id,
    required this.itemId,
    required this.amount,
    required this.currency,
    required this.unit,
    required this.kind,
    required this.capturedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    {
      map['amount'] = Variable<String>(
        $PriceSnapshotsTable.$converteramount.toSql(amount),
      );
    }
    map['currency'] = Variable<String>(currency);
    map['unit'] = Variable<String>(unit);
    map['kind'] = Variable<String>(kind);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    return map;
  }

  PriceSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return PriceSnapshotsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      amount: Value(amount),
      currency: Value(currency),
      unit: Value(unit),
      kind: Value(kind),
      capturedAt: Value(capturedAt),
    );
  }

  factory PriceSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceSnapshot(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      amount: serializer.fromJson<Decimal>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      unit: serializer.fromJson<String>(json['unit']),
      kind: serializer.fromJson<String>(json['kind']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'amount': serializer.toJson<Decimal>(amount),
      'currency': serializer.toJson<String>(currency),
      'unit': serializer.toJson<String>(unit),
      'kind': serializer.toJson<String>(kind),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
    };
  }

  PriceSnapshot copyWith({
    String? id,
    String? itemId,
    Decimal? amount,
    String? currency,
    String? unit,
    String? kind,
    DateTime? capturedAt,
  }) => PriceSnapshot(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    unit: unit ?? this.unit,
    kind: kind ?? this.kind,
    capturedAt: capturedAt ?? this.capturedAt,
  );
  PriceSnapshot copyWithCompanion(PriceSnapshotsCompanion data) {
    return PriceSnapshot(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      unit: data.unit.present ? data.unit.value : this.unit,
      kind: data.kind.present ? data.kind.value : this.kind,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceSnapshot(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('unit: $unit, ')
          ..write('kind: $kind, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, amount, currency, unit, kind, capturedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceSnapshot &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.unit == this.unit &&
          other.kind == this.kind &&
          other.capturedAt == this.capturedAt);
}

class PriceSnapshotsCompanion extends UpdateCompanion<PriceSnapshot> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<Decimal> amount;
  final Value<String> currency;
  final Value<String> unit;
  final Value<String> kind;
  final Value<DateTime> capturedAt;
  final Value<int> rowid;
  const PriceSnapshotsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.unit = const Value.absent(),
    this.kind = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceSnapshotsCompanion.insert({
    required String id,
    required String itemId,
    required Decimal amount,
    this.currency = const Value.absent(),
    required String unit,
    this.kind = const Value.absent(),
    required DateTime capturedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       amount = Value(amount),
       unit = Value(unit),
       capturedAt = Value(capturedAt);
  static Insertable<PriceSnapshot> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? amount,
    Expression<String>? currency,
    Expression<String>? unit,
    Expression<String>? kind,
    Expression<DateTime>? capturedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (unit != null) 'unit': unit,
      if (kind != null) 'kind': kind,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<Decimal>? amount,
    Value<String>? currency,
    Value<String>? unit,
    Value<String>? kind,
    Value<DateTime>? capturedAt,
    Value<int>? rowid,
  }) {
    return PriceSnapshotsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      kind: kind ?? this.kind,
      capturedAt: capturedAt ?? this.capturedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(
        $PriceSnapshotsTable.$converteramount.toSql(amount.value),
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('unit: $unit, ')
          ..write('kind: $kind, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final String key;
  final String value;
  const Preference({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(key: Value(key), value: Value(value));
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Preference copyWith({String? key, String? value}) =>
      Preference(key: key ?? this.key, value: value ?? this.value);
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.key == this.key &&
          other.value == this.value);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Preference> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalCategoriesTable localCategories = $LocalCategoriesTable(
    this,
  );
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $PriceSnapshotsTable priceSnapshots = $PriceSnapshotsTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localCategories,
    shoppingLists,
    shoppingListItems,
    priceSnapshots,
    preferences,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_list_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_list_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_list_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('price_snapshots', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LocalCategoriesTableCreateCompanionBuilder =
    LocalCategoriesCompanion Function({
      required String slug,
      required String name,
      required String iconKey,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$LocalCategoriesTableUpdateCompanionBuilder =
    LocalCategoriesCompanion Function({
      Value<String> slug,
      Value<String> name,
      Value<String> iconKey,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$LocalCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $LocalCategoriesTable, LocalCategory> {
  $$LocalCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
  _shoppingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingListItems,
        aliasName: 'local_categories__slug__shopping_list_items__category_slug',
      );

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager =
        $$ShoppingListItemsTableTableManager(
          $_db,
          $_db.shoppingListItems,
        ).filter(
          (f) => f.categorySlug.slug.sqlEquals($_itemColumn<String>('slug')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _shoppingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shoppingListItemsRefs(
    Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slug,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.categorySlug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> shoppingListItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.slug,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.categorySlug,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocalCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCategoriesTable,
          LocalCategory,
          $$LocalCategoriesTableFilterComposer,
          $$LocalCategoriesTableOrderingComposer,
          $$LocalCategoriesTableAnnotationComposer,
          $$LocalCategoriesTableCreateCompanionBuilder,
          $$LocalCategoriesTableUpdateCompanionBuilder,
          (LocalCategory, $$LocalCategoriesTableReferences),
          LocalCategory,
          PrefetchHooks Function({bool shoppingListItemsRefs})
        > {
  $$LocalCategoriesTableTableManager(
    _$AppDatabase db,
    $LocalCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCategoriesCompanion(
                slug: slug,
                name: name,
                iconKey: iconKey,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String slug,
                required String name,
                required String iconKey,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => LocalCategoriesCompanion.insert(
                slug: slug,
                name: name,
                iconKey: iconKey,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalCategoriesTable, LocalCategory>(table),
                  $$LocalCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingListItemsRefs) db.shoppingListItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      LocalCategory,
                      $LocalCategoriesTable,
                      ShoppingListItem,
                      $ShoppingListItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LocalCategoriesTableReferences
                          ._shoppingListItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocalCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).shoppingListItemsRefs,
                      currentColumn: 'slug',
                      referencedColumn: 'category_slug',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocalCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCategoriesTable,
      LocalCategory,
      $$LocalCategoriesTableFilterComposer,
      $$LocalCategoriesTableOrderingComposer,
      $$LocalCategoriesTableAnnotationComposer,
      $$LocalCategoriesTableCreateCompanionBuilder,
      $$LocalCategoriesTableUpdateCompanionBuilder,
      (LocalCategory, $$LocalCategoriesTableReferences),
      LocalCategory,
      PrefetchHooks Function({bool shoppingListItemsRefs})
    >;
typedef $$ShoppingListsTableCreateCompanionBuilder =
    ShoppingListsCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<Decimal?> budget,
      Value<String> shoppingState,
      Value<DateTime?> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });
typedef $$ShoppingListsTableUpdateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<Decimal?> budget,
      Value<String> shoppingState,
      Value<DateTime?> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });

final class $$ShoppingListsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList> {
  $$ShoppingListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
  _shoppingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingListItems,
        aliasName: 'shopping_lists__id__shopping_list_items__list_id',
      );

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
      $_db,
      $_db.shoppingListItems,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get budget =>
      $composableBuilder(
        column: $table.budget,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get shoppingState => $composableBuilder(
    column: $table.shoppingState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shoppingListItemsRefs(
    Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shoppingState => $composableBuilder(
    column: $table.shoppingState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<String> get shoppingState => $composableBuilder(
    column: $table.shoppingState,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  Expression<T> shoppingListItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.listId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShoppingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListsTable,
          ShoppingList,
          $$ShoppingListsTableFilterComposer,
          $$ShoppingListsTableOrderingComposer,
          $$ShoppingListsTableAnnotationComposer,
          $$ShoppingListsTableCreateCompanionBuilder,
          $$ShoppingListsTableUpdateCompanionBuilder,
          (ShoppingList, $$ShoppingListsTableReferences),
          ShoppingList,
          PrefetchHooks Function({bool shoppingListItemsRefs})
        > {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<Decimal?> budget = const Value.absent(),
                Value<String> shoppingState = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                budget: budget,
                shoppingState: shoppingState,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<Decimal?> budget = const Value.absent(),
                Value<String> shoppingState = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                budget: budget,
                shoppingState: shoppingState,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingListsTable, ShoppingList>(table),
                  $$ShoppingListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingListItemsRefs) db.shoppingListItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      ShoppingList,
                      $ShoppingListsTable,
                      ShoppingListItem,
                      $ShoppingListItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ShoppingListsTableReferences
                          ._shoppingListItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ShoppingListsTableReferences(
                            db,
                            table,
                            p0,
                          ).shoppingListItemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'list_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListsTable,
      ShoppingList,
      $$ShoppingListsTableFilterComposer,
      $$ShoppingListsTableOrderingComposer,
      $$ShoppingListsTableAnnotationComposer,
      $$ShoppingListsTableCreateCompanionBuilder,
      $$ShoppingListsTableUpdateCompanionBuilder,
      (ShoppingList, $$ShoppingListsTableReferences),
      ShoppingList,
      PrefetchHooks Function({bool shoppingListItemsRefs})
    >;
typedef $$ShoppingListItemsTableCreateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      required String id,
      required String listId,
      required String name,
      required Decimal quantity,
      required String unit,
      Value<String?> categorySlug,
      Value<bool> checked,
      required int position,
      Value<bool> notFound,
      Value<String?> substituteName,
      Value<Decimal?> foundPrice,
      Value<Decimal?> unitPrice,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShoppingListItemsTableUpdateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<String> id,
      Value<String> listId,
      Value<String> name,
      Value<Decimal> quantity,
      Value<String> unit,
      Value<String?> categorySlug,
      Value<bool> checked,
      Value<int> position,
      Value<bool> notFound,
      Value<String?> substituteName,
      Value<Decimal?> foundPrice,
      Value<Decimal?> unitPrice,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ShoppingListItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem
        > {
  $$ShoppingListItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListsTable _listIdTable(_$AppDatabase db) => db.shoppingLists
      .createAlias('shopping_list_items__list_id__shopping_lists__id');

  $$ShoppingListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<String>('list_id')!;

    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalCategoriesTable _categorySlugTable(_$AppDatabase db) =>
      db.localCategories.createAlias(
        'shopping_list_items__category_slug__local_categories__slug',
      );

  $$LocalCategoriesTableProcessedTableManager? get categorySlug {
    final $_column = $_itemColumn<String>('category_slug');
    if ($_column == null) return null;
    final manager = $$LocalCategoriesTableTableManager(
      $_db,
      $_db.localCategories,
    ).filter((f) => f.slug.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categorySlugTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PriceSnapshotsTable, List<PriceSnapshot>>
  _priceSnapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.priceSnapshots,
    aliasName: 'shopping_list_items__id__price_snapshots__item_id',
  );

  $$PriceSnapshotsTableProcessedTableManager get priceSnapshotsRefs {
    final manager = $$PriceSnapshotsTableTableManager(
      $_db,
      $_db.priceSnapshots,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceSnapshotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get quantity =>
      $composableBuilder(
        column: $table.quantity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notFound => $composableBuilder(
    column: $table.notFound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get substituteName => $composableBuilder(
    column: $table.substituteName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get foundPrice =>
      $composableBuilder(
        column: $table.foundPrice,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get unitPrice =>
      $composableBuilder(
        column: $table.unitPrice,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListsTableFilterComposer get listId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalCategoriesTableFilterComposer get categorySlug {
    final $$LocalCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categorySlug,
      referencedTable: $db.localCategories,
      getReferencedColumn: (t) => t.slug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.localCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> priceSnapshotsRefs(
    Expression<bool> Function($$PriceSnapshotsTableFilterComposer f) f,
  ) {
    final $$PriceSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceSnapshots,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PriceSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.priceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notFound => $composableBuilder(
    column: $table.notFound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get substituteName => $composableBuilder(
    column: $table.substituteName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foundPrice => $composableBuilder(
    column: $table.foundPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListsTableOrderingComposer get listId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalCategoriesTableOrderingComposer get categorySlug {
    final $$LocalCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categorySlug,
      referencedTable: $db.localCategories,
      getReferencedColumn: (t) => t.slug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.localCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get notFound =>
      $composableBuilder(column: $table.notFound, builder: (column) => column);

  GeneratedColumn<String> get substituteName => $composableBuilder(
    column: $table.substituteName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal?, String> get foundPrice =>
      $composableBuilder(
        column: $table.foundPrice,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal?, String> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get listId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalCategoriesTableAnnotationComposer get categorySlug {
    final $$LocalCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categorySlug,
      referencedTable: $db.localCategories,
      getReferencedColumn: (t) => t.slug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.localCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> priceSnapshotsRefs<T extends Object>(
    Expression<T> Function($$PriceSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$PriceSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceSnapshots,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PriceSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.priceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem,
          $$ShoppingListItemsTableFilterComposer,
          $$ShoppingListItemsTableOrderingComposer,
          $$ShoppingListItemsTableAnnotationComposer,
          $$ShoppingListItemsTableCreateCompanionBuilder,
          $$ShoppingListItemsTableUpdateCompanionBuilder,
          (ShoppingListItem, $$ShoppingListItemsTableReferences),
          ShoppingListItem,
          PrefetchHooks Function({
            bool listId,
            bool categorySlug,
            bool priceSnapshotsRefs,
          })
        > {
  $$ShoppingListItemsTableTableManager(
    _$AppDatabase db,
    $ShoppingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Decimal> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> categorySlug = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> notFound = const Value.absent(),
                Value<String?> substituteName = const Value.absent(),
                Value<Decimal?> foundPrice = const Value.absent(),
                Value<Decimal?> unitPrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion(
                id: id,
                listId: listId,
                name: name,
                quantity: quantity,
                unit: unit,
                categorySlug: categorySlug,
                checked: checked,
                position: position,
                notFound: notFound,
                substituteName: substituteName,
                foundPrice: foundPrice,
                unitPrice: unitPrice,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listId,
                required String name,
                required Decimal quantity,
                required String unit,
                Value<String?> categorySlug = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                required int position,
                Value<bool> notFound = const Value.absent(),
                Value<String?> substituteName = const Value.absent(),
                Value<Decimal?> foundPrice = const Value.absent(),
                Value<Decimal?> unitPrice = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion.insert(
                id: id,
                listId: listId,
                name: name,
                quantity: quantity,
                unit: unit,
                categorySlug: categorySlug,
                checked: checked,
                position: position,
                notFound: notFound,
                substituteName: substituteName,
                foundPrice: foundPrice,
                unitPrice: unitPrice,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingListItemsTable, ShoppingListItem>(table),
                  $$ShoppingListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                listId = false,
                categorySlug = false,
                priceSnapshotsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (priceSnapshotsRefs) db.priceSnapshots,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (listId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.listId,
                            referencedTable: $$ShoppingListItemsTableReferences
                                ._listIdTable(db),
                            referencedColumn: $$ShoppingListItemsTableReferences
                                ._listIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categorySlug) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categorySlug,
                            referencedTable: $$ShoppingListItemsTableReferences
                                ._categorySlugTable(db),
                            referencedColumn: $$ShoppingListItemsTableReferences
                                ._categorySlugTable(db)
                                .slug,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (priceSnapshotsRefs)
                        await $_getPrefetchedDataByColumns<
                          ShoppingListItem,
                          $ShoppingListItemsTable,
                          PriceSnapshot,
                          $PriceSnapshotsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingListItemsTableReferences
                              ._priceSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingListItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).priceSnapshotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShoppingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListItemsTable,
      ShoppingListItem,
      $$ShoppingListItemsTableFilterComposer,
      $$ShoppingListItemsTableOrderingComposer,
      $$ShoppingListItemsTableAnnotationComposer,
      $$ShoppingListItemsTableCreateCompanionBuilder,
      $$ShoppingListItemsTableUpdateCompanionBuilder,
      (ShoppingListItem, $$ShoppingListItemsTableReferences),
      ShoppingListItem,
      PrefetchHooks Function({
        bool listId,
        bool categorySlug,
        bool priceSnapshotsRefs,
      })
    >;
typedef $$PriceSnapshotsTableCreateCompanionBuilder =
    PriceSnapshotsCompanion Function({
      required String id,
      required String itemId,
      required Decimal amount,
      Value<String> currency,
      required String unit,
      Value<String> kind,
      required DateTime capturedAt,
      Value<int> rowid,
    });
typedef $$PriceSnapshotsTableUpdateCompanionBuilder =
    PriceSnapshotsCompanion Function({
      Value<String> id,
      Value<String> itemId,
      Value<Decimal> amount,
      Value<String> currency,
      Value<String> unit,
      Value<String> kind,
      Value<DateTime> capturedAt,
      Value<int> rowid,
    });

final class $$PriceSnapshotsTableReferences
    extends BaseReferences<_$AppDatabase, $PriceSnapshotsTable, PriceSnapshot> {
  $$PriceSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListItemsTable _itemIdTable(_$AppDatabase db) => db
      .shoppingListItems
      .createAlias('price_snapshots__item_id__shopping_list_items__id');

  $$ShoppingListItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ShoppingListItemsTableTableManager(
      $_db,
      $_db.shoppingListItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PriceSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $PriceSnapshotsTable> {
  $$PriceSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListItemsTableFilterComposer get itemId {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceSnapshotsTable> {
  $$PriceSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListItemsTableOrderingComposer get itemId {
    final $$ShoppingListItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceSnapshotsTable> {
  $$PriceSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  $$ShoppingListItemsTableAnnotationComposer get itemId {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.itemId,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PriceSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceSnapshotsTable,
          PriceSnapshot,
          $$PriceSnapshotsTableFilterComposer,
          $$PriceSnapshotsTableOrderingComposer,
          $$PriceSnapshotsTableAnnotationComposer,
          $$PriceSnapshotsTableCreateCompanionBuilder,
          $$PriceSnapshotsTableUpdateCompanionBuilder,
          (PriceSnapshot, $$PriceSnapshotsTableReferences),
          PriceSnapshot,
          PrefetchHooks Function({bool itemId})
        > {
  $$PriceSnapshotsTableTableManager(
    _$AppDatabase db,
    $PriceSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<Decimal> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceSnapshotsCompanion(
                id: id,
                itemId: itemId,
                amount: amount,
                currency: currency,
                unit: unit,
                kind: kind,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                required Decimal amount,
                Value<String> currency = const Value.absent(),
                required String unit,
                Value<String> kind = const Value.absent(),
                required DateTime capturedAt,
                Value<int> rowid = const Value.absent(),
              }) => PriceSnapshotsCompanion.insert(
                id: id,
                itemId: itemId,
                amount: amount,
                currency: currency,
                unit: unit,
                kind: kind,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PriceSnapshotsTable, PriceSnapshot>(table),
                  $$PriceSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$PriceSnapshotsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$PriceSnapshotsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PriceSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceSnapshotsTable,
      PriceSnapshot,
      $$PriceSnapshotsTableFilterComposer,
      $$PriceSnapshotsTableOrderingComposer,
      $$PriceSnapshotsTableAnnotationComposer,
      $$PriceSnapshotsTableCreateCompanionBuilder,
      $$PriceSnapshotsTableUpdateCompanionBuilder,
      (PriceSnapshot, $$PriceSnapshotsTableReferences),
      PriceSnapshot,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PreferencesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferencesTable, Preference>(table),
                  BaseReferences<_$AppDatabase, $PreferencesTable, Preference>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalCategoriesTableTableManager get localCategories =>
      $$LocalCategoriesTableTableManager(_db, _db.localCategories);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$PriceSnapshotsTableTableManager get priceSnapshots =>
      $$PriceSnapshotsTableTableManager(_db, _db.priceSnapshots);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
}
