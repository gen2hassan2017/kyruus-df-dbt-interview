import pandas as pd
import duckdb
import os


def query_duckdb():
    """
    Query the provider_address_agg table from DuckDB and return all rows.

    Returns:
        pandas.DataFrame: All rows from the provider_address_agg table
    """
    # Path to the DuckDB database file
    db_path = os.path.join("provider_pipeline", "dev.duckdb")

    # Connect to DuckDB database
    conn = duckdb.connect(db_path)

    try:
        # Query the provider_address_agg table
        query = "SELECT * FROM provider_address_agg"
        result = conn.execute(query).fetchdf()

        # Print the results
        print("Provider Address Aggregation Results:")
        print("=" * 50)
        print(result)
        print(f"\nTotal rows: {len(result)}")

        return result

    except Exception as e:
        print(f"Error querying database: {e}")
        return pd.DataFrame()

    finally:
        # Close the connection
        conn.close()


if __name__ == "__main__":
    # Run the query when script is executed directly
    query_duckdb()